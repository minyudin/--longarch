<template>
  <div class="dash">
    <!-- 统计卡片 -->
    <section class="cards-row">
      <div
        v-for="(s, i) in stats"
        :key="s.label"
        :class="['metric-card', { highlight: i === 0 }]"
        :style="i === 0 ? { background: 'linear-gradient(158deg, #40ddff 0%, #14bae3 40%, #0b98c5 100%)' } : {}"
      >
        <div class="metric-icon" :style="{ background: i === 0 ? 'rgba(255,255,255,0.2)' : s.iconBg }">
          <el-icon :size="20" :color="i === 0 ? '#fff' : s.iconColor"><component :is="s.icon" /></el-icon>
        </div>
        <div class="metric-body">
          <span class="metric-val">{{ s.value }}</span>
          <span class="metric-label">{{ s.label }}</span>
        </div>
      </div>
    </section>

    <!-- 订单状态分布（真实数据） -->
    <section class="chart-row">
      <div class="chart-panel">
        <div class="panel-head">
          <h3>订单状态分布</h3>
        </div>
        <v-chart v-if="pieLoaded" :option="pieOption" style="height: 300px;" autoresize />
        <div v-else class="chart-empty">加载中...</div>
      </div>

      <div class="chart-panel">
        <div class="panel-head">
          <h3>任务状态分布</h3>
        </div>
        <v-chart v-if="taskPieLoaded" :option="taskPieOption" style="height: 300px;" autoresize />
        <div v-else class="chart-empty">加载中...</div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart } from 'echarts/charts'
import { TooltipComponent, LegendComponent } from 'echarts/components'
import { listUsers, listOrders, listCodes, listPlots, listDevices, listTasks } from '@/api/admin'

use([CanvasRenderer, PieChart, TooltipComponent, LegendComponent])

const stats = ref([
  { label: '用户总数', value: '-', icon: 'User', iconBg: 'rgba(64,221,255,0.12)', iconColor: '#40ddff' },
  { label: '认养订单', value: '-', icon: 'ShoppingCart', iconBg: 'rgba(255,64,154,0.12)', iconColor: '#ff409a' },
  { label: '认养码', value: '-', icon: 'Key', iconBg: 'rgba(196,56,239,0.12)', iconColor: '#c438ef' },
  { label: '地块数量', value: '-', icon: 'MapLocation', iconBg: 'rgba(46,204,113,0.12)', iconColor: '#2ecc71' },
  { label: '设备数量', value: '-', icon: 'Monitor', iconBg: 'rgba(243,156,18,0.12)', iconColor: '#f39c12' },
  { label: '操作任务', value: '-', icon: 'List', iconBg: 'rgba(64,221,255,0.12)', iconColor: '#40ddff' }
])

const pieLoaded = ref(false)
const taskPieLoaded = ref(false)

function makePieOption(data) {
  return {
    tooltip: {
      backgroundColor: 'rgba(26,23,64,0.9)',
      borderColor: '#312f62',
      textStyle: { color: '#b1afcd' }
    },
    legend: {
      bottom: 10,
      textStyle: { color: '#6f6c99', fontSize: 11 },
      itemWidth: 8, itemHeight: 8, itemGap: 16
    },
    series: [{
      type: 'pie',
      radius: ['50%', '75%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 6, borderColor: '#17153a', borderWidth: 3 },
      label: { show: false },
      emphasis: {
        label: { show: true, color: '#fff', fontSize: 14, fontWeight: 'bold' },
        itemStyle: { shadowBlur: 20, shadowColor: 'rgba(64,221,255,0.3)' }
      },
      data
    }]
  }
}

const statusColors = {
  pending: '#f39c12', active: '#40ddff', completed: '#2ecc71', cancelled: '#6f6c99',
  queued: '#f39c12', executing: '#40ddff', failed: '#ff409a',
  network_pending_confirmation: '#c438ef'
}
const statusLabels = {
  pending: '待处理', active: '进行中', completed: '已完成', cancelled: '已取消',
  queued: '排队中', executing: '执行中', failed: '失败',
  network_pending_confirmation: '网络待确认'
}

const pieOption = ref({})
const taskPieOption = ref({})

function countByField(list, field) {
  const map = {}
  for (const item of list) {
    const v = item[field] || 'unknown'
    map[v] = (map[v] || 0) + 1
  }
  return Object.entries(map).map(([name, value]) => ({
    value,
    name: statusLabels[name] || name,
    itemStyle: { color: statusColors[name] || '#6f6c99' }
  }))
}

onMounted(async () => {
  try {
    const [users, orders, codes, plots, devices, tasks] = await Promise.all([
      listUsers({ pageNo: 1, pageSize: 1 }),
      listOrders({ pageNo: 1, pageSize: 100 }),
      listCodes({ pageNo: 1, pageSize: 1 }),
      listPlots({ pageNo: 1, pageSize: 1 }),
      listDevices({ pageNo: 1, pageSize: 1 }),
      listTasks({ pageNo: 1, pageSize: 100 })
    ])
    stats.value[0].value = users.total ?? 0
    stats.value[1].value = orders.total ?? 0
    stats.value[2].value = codes.total ?? 0
    stats.value[3].value = plots.total ?? 0
    stats.value[4].value = devices.total ?? 0
    stats.value[5].value = tasks.total ?? 0

    // 订单状态饼图 — 真实数据
    const orderData = countByField(orders.list, 'orderStatus')
    if (orderData.length) {
      pieOption.value = makePieOption(orderData)
      pieLoaded.value = true
    }

    // 任务状态饼图 — 真实数据
    const taskData = countByField(tasks.list, 'taskStatus')
    if (taskData.length) {
      taskPieOption.value = makePieOption(taskData)
      taskPieLoaded.value = true
    }
  } catch { /* handled by interceptor */ }
})
</script>

<style lang="scss" scoped>
.cards-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 14px;
  margin-bottom: 24px;
}

.metric-card {
  background: rgba(49, 47, 98, 0.3);
  border: 1px solid rgba(49, 47, 98, 0.6);
  border-radius: 12px;
  padding: 18px 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: all 0.3s ease;

  &:hover {
    border-color: rgba(64, 221, 255, 0.25);
    box-shadow: 0 0 24px rgba(64, 221, 255, 0.08);
    transform: translateY(-2px);
  }

  &.highlight {
    border-color: transparent;
    box-shadow: 0 8px 32px rgba(11, 152, 197, 0.25);
    .metric-val, .metric-label { color: #fff; }
  }
}

.metric-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.metric-body {
  flex: 1;
  .metric-val {
    display: block;
    font-size: 22px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.9);
    line-height: 1;
  }
  .metric-label {
    display: block;
    font-size: 11px;
    color: #6f6c99;
    margin-top: 4px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
}

.chart-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.chart-panel {
  background: rgba(49, 47, 98, 0.3);
  border: 1px solid rgba(49, 47, 98, 0.6);
  border-radius: 12px;
  padding: 22px 24px;
  -webkit-backdrop-filter: blur(8px);
  backdrop-filter: blur(8px);
}

.panel-head {
  margin-bottom: 8px;
  h3 {
    font-size: 15px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.88);
  }
}

.chart-empty {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #5b5a99;
  font-size: 13px;
}

@media (max-width: 900px) {
  .chart-row { grid-template-columns: 1fr; }
}
</style>
