<template>
  <div>
    <div class="page-header">
      <h2>设备状态总览</h2>
      <el-button type="primary" @click="refreshAll">刷新</el-button>
    </div>

    <!-- 设备统计卡片 -->
    <el-row :gutter="16" style="margin-bottom: 20px;">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-label">地块总数</div>
            <div class="stat-value">{{ overview.totalPlots }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-for="stat in overview.deviceStats" :key="stat.deviceType">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-label">{{ deviceTypeLabel(stat.deviceType) }}</div>
            <div class="stat-value">{{ stat.total }}</div>
            <div class="stat-detail">
              <el-tag type="success" size="small">在线 {{ stat.online }}</el-tag>
              <el-tag type="info" size="small">已注册 {{ stat.registered }}</el-tag>
              <el-tag type="danger" size="small">离线 {{ stat.offline }}</el-tag>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 地块数据总览 -->
    <div class="page-header" style="margin-top: 24px;">
      <h3>地块数据总览</h3>
      <el-select v-model="selectedPlotId" placeholder="选择地块查看数据" style="width: 220px" @change="fetchPlotOverview">
        <el-option v-for="p in plotOptions" :key="p.plotId" :label="p.plotName" :value="p.plotId" />
      </el-select>
    </div>

    <template v-if="plotOverview.plotId">
      <div style="margin-bottom: 8px; color: #909399; font-size: 13px;">
        地块：<strong style="color: #303133;">{{ plotOverview.plotName }}</strong>
        <span style="margin-left: 16px;">更新时间：{{ plotOverview.updatedAt }}</span>
      </div>

      <!-- 环境传感器数据 -->
      <el-card shadow="hover" style="margin-bottom: 16px;">
        <template #header>
          <div style="display: flex; align-items: center; gap: 8px;">
            <el-tag type="warning" size="small">环境</el-tag>
            <span style="font-weight: 600;">环境传感器（温湿度/光照/CO2）</span>
            <span style="color: #909399; font-size: 12px; margin-left: auto;">共 {{ plotOverview.environment.length }} 个设备</span>
          </div>
        </template>
        <el-empty v-if="!plotOverview.environment.length" description="该地块暂无环境传感器" :image-size="60" />
        <el-row :gutter="16" v-else>
          <el-col :span="24" v-for="sensor in plotOverview.environment" :key="sensor.sensorId" style="margin-bottom: 12px;">
            <div class="sensor-row">
              <div class="sensor-header">
                <el-tag :type="sensor.status === 'online' ? 'success' : 'danger'" size="small">{{ sensor.status }}</el-tag>
                <span class="sensor-name">{{ sensor.sensorName }}</span>
                <span class="sensor-deviceno">{{ sensor.deviceNo }}</span>
                <span class="sensor-time" v-if="sensor.lastSampleAt">{{ sensor.lastSampleAt }}</span>
                <el-button size="small" type="primary" link @click="goHistory(sensor)">历史</el-button>
              </div>
              <div class="metric-list" v-if="sensor.metrics && Object.keys(sensor.metrics).length">
                <div class="metric-item" v-for="(val, key) in sensor.metrics" :key="key">
                  <span class="metric-key">{{ key }}</span>
                  <span class="metric-val">{{ val }}</span>
                </div>
              </div>
              <div v-else class="no-data">暂无上报数据</div>
            </div>
          </el-col>
        </el-row>
      </el-card>

      <!-- 土壤传感器数据 -->
      <el-card shadow="hover" style="margin-bottom: 16px;">
        <template #header>
          <div style="display: flex; align-items: center; gap: 8px;">
            <el-tag type="success" size="small">土壤</el-tag>
            <span style="font-weight: 600;">土壤传感器（NPK/pH/土温土湿）</span>
            <span style="color: #909399; font-size: 12px; margin-left: auto;">共 {{ plotOverview.soil.length }} 个点位</span>
          </div>
        </template>
        <el-empty v-if="!plotOverview.soil.length" description="该地块暂无土壤传感器" :image-size="60" />
        <el-row :gutter="16" v-else>
          <el-col :span="12" :md="8" v-for="sensor in plotOverview.soil" :key="sensor.sensorId" style="margin-bottom: 12px;">
            <el-card shadow="never" class="soil-card">
              <div class="sensor-header">
                <el-tag :type="sensor.status === 'online' ? 'success' : 'danger'" size="small">{{ sensor.status }}</el-tag>
                <span class="sensor-name">{{ sensor.sensorName }}</span>
                <el-button size="small" type="primary" link style="margin-left: auto;" @click="goHistory(sensor)">历史</el-button>
              </div>
              <div class="sensor-deviceno" style="margin: 4px 0;">{{ sensor.deviceNo }}</div>
              <div class="metric-list" v-if="sensor.metrics && Object.keys(sensor.metrics).length">
                <div class="metric-item" v-for="(val, key) in sensor.metrics" :key="key">
                  <span class="metric-key">{{ key }}</span>
                  <span class="metric-val">{{ val }}</span>
                </div>
              </div>
              <div v-else class="no-data">暂无上报数据</div>
              <div class="sensor-time" v-if="sensor.lastSampleAt" style="margin-top: 6px;">{{ sensor.lastSampleAt }}</div>
            </el-card>
          </el-col>
        </el-row>
      </el-card>
    </template>
    <el-empty v-else description="请先选择一个地块查看传感器数据" :image-size="80" style="margin: 40px 0;" />

    <!-- 传感器设备列表（全局） -->
    <div class="page-header" style="margin-top: 24px;">
      <h3>传感器设备列表</h3>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.plotId" placeholder="筛选地块" clearable style="width: 180px" @change="fetchSensors">
        <el-option v-for="p in plotOptions" :key="p.plotId" :label="p.plotName" :value="p.plotId" />
      </el-select>
      <el-select v-model="query.category" placeholder="传感器分类" clearable style="width: 150px" @change="fetchSensors">
        <el-option label="环境传感器" value="environment" />
        <el-option label="土壤传感器" value="soil" />
      </el-select>
      <el-button type="primary" @click="fetchSensors">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="sensorList" v-loading="sensorLoading">
        <el-table-column prop="sensorId" label="ID" width="60" />
        <el-table-column prop="deviceNo" label="设备编号" width="130" />
        <el-table-column prop="sensorName" label="传感器名称" width="160" />
        <el-table-column prop="plotName" label="所属地块" width="120" />
        <el-table-column prop="category" label="分类" width="80">
          <template #default="{ row }">
            <el-tag :type="row.category === 'environment' ? 'warning' : 'success'" size="small">
              {{ row.category === 'environment' ? '环境' : '土壤' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sensorType" label="类型" width="100" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 'online' ? 'success' : row.status === 'registered' ? 'info' : 'danger'" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="最新指标" min-width="260">
          <template #default="{ row }">
            <template v-if="row.latestMetrics && Object.keys(row.latestMetrics).length">
              <el-tag v-for="(val, key) in row.latestMetrics" :key="key" size="small" style="margin: 2px 4px 2px 0;">
                {{ key }}: {{ val }}
              </el-tag>
            </template>
            <span v-else style="color: #c0c4cc;">暂无数据</span>
          </template>
        </el-table-column>
        <el-table-column prop="lastSampleAt" label="最后采样" width="170" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="goHistory(row)">历史数据</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="sensorTotal" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchSensors" @current-change="fetchSensors" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getDeviceOverview, listSensorDevices, listPlots, getPlotSensorOverview } from '@/api/admin'

const router = useRouter()

const overview = reactive({ totalPlots: 0, deviceStats: [] })
const sensorList = ref([])
const sensorTotal = ref(0)
const sensorLoading = ref(false)
const plotOptions = ref([])
const query = reactive({ pageNo: 1, pageSize: 10, plotId: null, category: '' })

const selectedPlotId = ref(null)
const plotOverview = reactive({ plotId: null, plotName: '', environment: [], soil: [], updatedAt: '' })

const deviceTypeLabels = { camera: '摄像头', sensor: '传感器', actuator: '执行设备', screen: '大屏' }
function deviceTypeLabel(type) { return deviceTypeLabels[type] || type }

async function fetchOverviewStats() {
  try {
    const res = await getDeviceOverview()
    overview.totalPlots = res.totalPlots
    overview.deviceStats = res.deviceStats || []
  } catch {}
}

async function fetchPlotOverview() {
  if (!selectedPlotId.value) {
    plotOverview.plotId = null
    return
  }
  try {
    const res = await getPlotSensorOverview(selectedPlotId.value)
    plotOverview.plotId = res.plotId
    plotOverview.plotName = res.plotName
    plotOverview.environment = res.environment || []
    plotOverview.soil = res.soil || []
    plotOverview.updatedAt = res.updatedAt
  } catch {}
}

async function fetchSensors() {
  sensorLoading.value = true
  try {
    const params = { pageNo: query.pageNo, pageSize: query.pageSize }
    if (query.plotId) params.plotId = query.plotId
    if (query.category) params.category = query.category
    const res = await listSensorDevices(params)
    sensorList.value = res.list
    sensorTotal.value = res.total
  } catch {} finally { sensorLoading.value = false }
}

async function fetchPlotOptions() {
  try {
    const res = await listPlots({ pageNo: 1, pageSize: 100 })
    plotOptions.value = res.list || []
  } catch {}
}

function refreshAll() {
  fetchOverviewStats()
  if (selectedPlotId.value) fetchPlotOverview()
  fetchSensors()
}

function goHistory(row) {
  router.push({ path: '/sensor-data', query: { sensorId: row.sensorId, sensorName: row.sensorName, deviceNo: row.deviceNo } })
}

onMounted(() => { fetchOverviewStats(); fetchSensors(); fetchPlotOptions() })
</script>

<style scoped>
.stat-card { text-align: center; }
.stat-label { font-size: 14px; color: #909399; margin-bottom: 8px; }
.stat-value { font-size: 32px; font-weight: bold; color: #303133; }
.stat-detail { margin-top: 10px; display: flex; gap: 6px; justify-content: center; flex-wrap: wrap; }

.sensor-row { padding: 10px 14px; background: #fafafa; border-radius: 6px; border: 1px solid #ebeef5; }
.sensor-header { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.sensor-name { font-weight: 600; font-size: 14px; color: #303133; }
.sensor-deviceno { font-size: 12px; color: #909399; font-family: monospace; }
.sensor-time { font-size: 12px; color: #c0c4cc; margin-left: auto; }

.metric-list { display: flex; flex-wrap: wrap; gap: 8px; }
.metric-item { display: flex; flex-direction: column; align-items: center; min-width: 70px; padding: 6px 12px; background: #fff; border-radius: 6px; border: 1px solid #e4e7ed; }
.metric-key { font-size: 11px; color: #909399; margin-bottom: 2px; }
.metric-val { font-size: 18px; font-weight: 700; color: #303133; }

.soil-card { border: 1px solid #e4e7ed; }
.no-data { color: #c0c4cc; font-size: 13px; padding: 8px 0; }
</style>
