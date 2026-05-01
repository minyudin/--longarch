<template>
  <div>
    <div class="page-header">
      <h2>传感器历史数据</h2>
      <el-button @click="$router.back()">返回</el-button>
    </div>

    <el-descriptions :column="3" border style="margin-bottom: 20px;">
      <el-descriptions-item label="设备编号">{{ deviceNo }}</el-descriptions-item>
      <el-descriptions-item label="传感器名称">{{ sensorName }}</el-descriptions-item>
      <el-descriptions-item label="传感器ID">{{ sensorId }}</el-descriptions-item>
    </el-descriptions>

    <div class="filter-bar">
      <el-input v-model="query.sensorType" placeholder="筛选指标类型（如 温度、pH）" clearable style="width: 200px" @keyup.enter="fetchData" />
      <el-button type="primary" @click="fetchData">查询</el-button>
      <el-button @click="query.sensorType = ''; fetchData()">重置</el-button>
    </div>

    <!-- 折线图 -->
    <el-card shadow="hover" style="margin-bottom: 20px;" v-if="chartData.length > 0">
      <div ref="chartRef" style="width: 100%; height: 360px;"></div>
    </el-card>
    <el-empty v-else description="暂无历史数据" />

    <!-- 数据表格 -->
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="sensorType" label="指标类型" width="120" />
        <el-table-column prop="value" label="数值" width="120" />
        <el-table-column prop="sampleAt" label="采样时间" width="200" />
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[50,100,200]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { listSensorData } from '@/api/admin'
import * as echarts from 'echarts'

const route = useRoute()
const sensorId = ref(route.query.sensorId || '')
const sensorName = ref(route.query.sensorName || '')
const deviceNo = ref(route.query.deviceNo || '')

const loading = ref(false)
const list = ref([])
const total = ref(0)
const chartData = ref([])
const chartRef = ref(null)
let chartInstance = null

const query = reactive({ pageNo: 1, pageSize: 50, sensorType: '' })

async function fetchData() {
  if (!sensorId.value) return
  loading.value = true
  try {
    const params = { pageNo: query.pageNo, pageSize: query.pageSize }
    if (query.sensorType) params.sensorType = query.sensorType
    const res = await listSensorData(sensorId.value, params)
    list.value = res.list || []
    total.value = res.total || 0

    // 用表格数据画折线图（取前100条，按时间正序）
    chartData.value = [...list.value].reverse().slice(-100)
    await nextTick()
    renderChart()
  } catch {} finally { loading.value = false }
}

function renderChart() {
  if (!chartRef.value || chartData.value.length === 0) return

  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }

  // 按指标类型分组
  const groups = {}
  for (const item of chartData.value) {
    if (!groups[item.sensorType]) groups[item.sensorType] = []
    groups[item.sensorType].push(item)
  }

  const series = Object.entries(groups).map(([type, data]) => ({
    name: type,
    type: 'line',
    smooth: true,
    data: data.map(d => [d.sampleAt, parseFloat(d.value)]),
    showSymbol: false
  }))

  chartInstance.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: Object.keys(groups), bottom: 0 },
    grid: { left: 60, right: 30, top: 20, bottom: 40 },
    xAxis: { type: 'category', data: chartData.value.map(d => d.sampleAt), axisLabel: { rotate: 30, fontSize: 10 } },
    yAxis: { type: 'value' },
    series
  }, true)
}

onMounted(fetchData)

watch(() => route.query, () => {
  sensorId.value = route.query.sensorId || ''
  sensorName.value = route.query.sensorName || ''
  deviceNo.value = route.query.deviceNo || ''
  fetchData()
})
</script>
