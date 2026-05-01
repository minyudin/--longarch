<template>
  <div>
    <div class="page-header">
      <h2>地块管理</h2>
      <el-button type="primary" @click="showCreate = true"><el-icon><Plus /></el-icon> 新建地块</el-button>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.parentId" placeholder="所属大棚" clearable style="width: 160px" @change="fetchData">
        <el-option v-for="g in greenhouses" :key="g.plotId" :label="g.plotName" :value="g.plotId" />
      </el-select>
      <el-select v-model="query.plotStatus" placeholder="地块状态" clearable style="width: 140px" @change="fetchData">
        <el-option label="激活" value="active" />
        <el-option label="休耕" value="fallow" />
      </el-select>
      <el-button type="primary" @click="fetchData">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="plotId" label="ID" width="60" />
        <el-table-column prop="plotNo" label="编号" width="140" />
        <el-table-column prop="plotName" label="名称" >
          <template #default="{ row }">
            <el-tag v-if="!row.parentId" type="warning" size="small" style="margin-right:6px">大棚</el-tag>
            <el-tag v-else size="small" style="margin-right:6px">点位</el-tag>
            {{ row.plotName }}
          </template>
        </el-table-column>
        <el-table-column prop="parentName" label="所属大棚" width="120">
          <template #default="{ row }">{{ row.parentName || '—' }}</template>
        </el-table-column>
        <el-table-column prop="farmName" label="所属基地" width="120" />
        <el-table-column prop="areaSize" label="面积" width="80" />
        <el-table-column prop="plotStatus" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.plotStatus==='active' ? 'success' : 'info'" size="small">{{ row.plotStatus }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="420" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="openBindCamera(row)">绑定摄像头</el-button>
            <el-button size="small" type="warning" link @click="openBindActuator(row)">绑定设备</el-button>
            <el-button size="small" type="success" link @click="openBindSensor(row)">绑定传感器</el-button>
            <el-button size="small" type="info" link @click="openCreateBatch(row)">新建批次</el-button>
            <el-button size="small" type="danger" link @click="openBindScreen(row)">绑定大屏</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>

    <!-- 新建地块 -->
    <el-dialog v-model="showCreate" title="新建地块" width="480px" destroy-on-close>
      <el-form :model="createForm" label-width="80px">
        <el-form-item label="地块名称" required><el-input v-model="createForm.plotName" /></el-form-item>
        <el-form-item label="地块编号"><el-input v-model="createForm.plotNo" /></el-form-item>
        <el-form-item label="所属大棚">
          <el-select v-model="createForm.parentId" placeholder="不选则为大棚级别" clearable style="width: 100%">
            <el-option v-for="g in greenhouses" :key="g.plotId" :label="g.plotName" :value="g.plotId" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属基地"><el-input v-model="createForm.farmName" :disabled="!!createForm.parentId" :placeholder="createForm.parentId ? '自动继承大棚基地' : ''" /></el-form-item>
        <el-form-item label="面积"><el-input-number v-model="createForm.areaSize" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="经度"><el-input-number v-model="createForm.longitude" :precision="6" /></el-form-item>
        <el-form-item label="纬度"><el-input-number v-model="createForm.latitude" :precision="6" /></el-form-item>
        <el-form-item label="简介"><el-input v-model="createForm.introText" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreate = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doCreate">提交</el-button>
      </template>
    </el-dialog>

    <!-- 绑定摄像头 -->
    <el-dialog v-model="showCamera" title="绑定摄像头到地块" width="440px" destroy-on-close>
      <el-form :model="cameraForm" label-width="80px">
        <el-form-item label="地块">{{ cameraForm._plotName }}</el-form-item>
        <el-form-item label="摄像头名" required><el-input v-model="cameraForm.cameraName" /></el-form-item>
        <el-form-item label="设备编号"><el-input v-model="cameraForm.deviceNo" /></el-form-item>
        <el-form-item label="流协议">
          <el-select v-model="cameraForm.streamProtocol" style="width: 100%">
            <el-option label="RTSP" value="rtsp" />
            <el-option label="RTMP" value="rtmp" />
            <el-option label="HLS" value="hls" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCamera = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doBindCamera">绑定</el-button>
      </template>
    </el-dialog>

    <!-- 绑定传感器 -->
    <el-dialog v-model="showSensor" title="绑定传感器到地块" width="440px" destroy-on-close>
      <el-form :model="sensorForm" label-width="80px">
        <el-form-item label="地块">{{ sensorForm._plotName }}</el-form-item>
        <el-form-item label="传感器名" required><el-input v-model="sensorForm.sensorName" /></el-form-item>
        <el-form-item label="设备编号"><el-input v-model="sensorForm.deviceNo" placeholder="留空自动生成" /></el-form-item>
        <el-form-item label="传感器分类" required>
          <el-select v-model="sensorForm.category" style="width: 100%">
            <el-option label="环境传感器（温湿度/光照/CO2）" value="environment" />
            <el-option label="土壤传感器（NPK/pH/土温土湿）" value="soil" />
          </el-select>
        </el-form-item>
        <el-form-item label="传感器类型">
          <el-input v-model="sensorForm.sensorType" placeholder="如 env_multi / soil_npk / soil_ph / soil_th" />
        </el-form-item>
        <el-form-item label="数据单位"><el-input v-model="sensorForm.unit" placeholder="如 %、℃、lux（多指标可留空）" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showSensor = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doBindSensor">绑定</el-button>
      </template>
    </el-dialog>

    <!-- 创建作物批次 -->
    <el-dialog v-model="showBatch" title="创建作物批次" width="440px" destroy-on-close>
      <el-form :model="batchForm" label-width="90px">
        <el-form-item label="地块">{{ batchForm._plotName }}</el-form-item>
        <el-form-item label="作物名称" required><el-input v-model="batchForm.cropName" /></el-form-item>
        <el-form-item label="品种名称"><el-input v-model="batchForm.varietyName" /></el-form-item>
        <el-form-item label="生长阶段">
          <el-select v-model="batchForm.growthStage" style="width: 100%">
            <el-option label="播种期" value="seedling" />
            <el-option label="生长期" value="growing" />
            <el-option label="成熟期" value="mature" />
          </el-select>
        </el-form-item>
        <el-form-item label="播种时间"><el-date-picker v-model="batchForm.sowingAt" type="datetime" format="YYYY-MM-DD HH:mm:ss" value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" /></el-form-item>
        <el-form-item label="预计收获"><el-date-picker v-model="batchForm.expectedHarvestAt" type="datetime" format="YYYY-MM-DD HH:mm:ss" value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showBatch = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doCreateBatch">创建</el-button>
      </template>
    </el-dialog>

    <!-- 绑定摄像头成功信息 -->
    <el-dialog v-model="showCameraResult" title="摄像头绑定成功" width="520px">
      <el-alert type="success" :closable="false" show-icon>
        <template #title>摄像头已绑定，请将以下信息告知硬件师</template>
      </el-alert>
      <el-descriptions :column="1" border style="margin-top: 16px;">
        <el-descriptions-item label="设备编号">{{ cameraResultInfo.deviceNo }}</el-descriptions-item>
        <el-descriptions-item label="RTMP 推流地址">
          <code style="word-break: break-all;">{{ cameraResultInfo.pushUrl }}</code>
          <el-button size="small" link type="primary" style="margin-left: 8px;" @click="copyText(cameraResultInfo.pushUrl)">复制</el-button>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="showCameraResult = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 绑定传感器成功信息 -->
    <el-dialog v-model="showSensorResult" title="传感器绑定成功" width="520px">
      <el-alert type="success" :closable="false" show-icon>
        <template #title>传感器已绑定，请将以下信息告知硬件师</template>
      </el-alert>
      <el-descriptions :column="1" border style="margin-top: 16px;">
        <el-descriptions-item label="设备编号">{{ sensorResultInfo.deviceNo }}</el-descriptions-item>
        <el-descriptions-item label="MQTT Topic">
          <code style="word-break: break-all;">{{ sensorResultInfo.topic }}</code>
          <el-button size="small" link type="primary" style="margin-left: 8px;" @click="copyText(sensorResultInfo.topic)">复制</el-button>
        </el-descriptions-item>
        <el-descriptions-item label="数据格式示例">
          <code>{"指标名": 数值, "指标名2": 数值}</code>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="showSensorResult = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 绑定大屏 -->
    <el-dialog v-model="showScreen" title="绑定大屏到地块" width="440px" destroy-on-close>
      <el-form :model="screenForm" label-width="80px">
        <el-form-item label="地块">{{ screenForm._plotName }}</el-form-item>
        <el-form-item label="大屏名称" required><el-input v-model="screenForm.screenName" placeholder="如：1号大棚展示屏" /></el-form-item>
        <el-form-item label="设备编号"><el-input v-model="screenForm.deviceNo" placeholder="留空自动生成" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showScreen = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doBindScreen">绑定</el-button>
      </template>
    </el-dialog>

    <!-- 大屏 Token 展示 -->
    <el-dialog v-model="showScreenToken" title="大屏绑定成功" width="480px">
      <el-alert type="success" :closable="false" show-icon>
        <template #title>大屏已绑定，请将以下 Token 配置到大屏浏览器</template>
      </el-alert>
      <div style="margin-top: 16px; padding: 12px; background: #f5f7fa; border-radius: 4px; font-family: monospace; word-break: break-all;">
        {{ screenTokenResult }}
      </div>
      <div style="margin-top: 8px; color: #909399; font-size: 12px;">大屏访问地址示例：http://大屏地址/?token={{ screenTokenResult }}</div>
      <template #footer>
        <el-button type="primary" @click="copyText(screenTokenResult)">复制 Token</el-button>
        <el-button @click="showScreenToken = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 绑定执行设备 -->
    <el-dialog v-model="showActuator" title="绑定执行设备到地块" width="440px" destroy-on-close>
      <el-form :model="actuatorForm" label-width="80px">
        <el-form-item label="地块">{{ actuatorForm._plotName }}</el-form-item>
        <el-form-item label="设备名称" required><el-input v-model="actuatorForm.deviceName" /></el-form-item>
        <el-form-item label="设备编号"><el-input v-model="actuatorForm.deviceNo" /></el-form-item>
        <el-form-item label="设备类型" required>
          <el-select v-model="actuatorForm.deviceType" style="width: 100%">
            <el-option label="水肥一体机" value="fertigation_machine" />
            <el-option label="遮阳帘控制器" value="shade_controller" />
            <el-option label="湿帘控制器" value="wet_curtain_controller" />
            <el-option label="换气扇控制器" value="ventilation_fan_controller" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showActuator = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doBindActuator">绑定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listPlots, createPlot, bindCamera, bindActuator, bindSensor, bindScreen, createCropBatch } from '@/api/admin'

const loading = ref(false)
const submitting = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, plotStatus: '', parentId: null })

async function fetchData() {
  loading.value = true
  try { const res = await listPlots(query); list.value = res.list; total.value = res.total } catch {} finally { loading.value = false }
}
async function fetchGreenhouses() {
  try {
    const res = await listPlots({ pageNo: 1, pageSize: 100 })
    greenhouses.value = (res.list || []).filter(p => !p.parentId)
  } catch {}
}
onMounted(() => { fetchData(); fetchGreenhouses() })

// 新建地块
const showCreate = ref(false)
const greenhouses = ref([])
const createForm = reactive({ plotName: '', plotNo: '', farmName: '', parentId: null, areaSize: null, longitude: null, latitude: null, introText: '' })
async function doCreate() {
  if (!createForm.plotName) return ElMessage.warning('请填写地块名称')
  submitting.value = true
  try {
    const payload = { ...createForm, parentId: createForm.parentId || undefined }
    await createPlot(payload)
    ElMessage.success('地块创建成功')
    showCreate.value = false
    fetchData()
    fetchGreenhouses()
  } catch {} finally { submitting.value = false }
}

// 绑定摄像头
const showCamera = ref(false)
const cameraForm = reactive({ _plotId: null, _plotName: '', cameraName: '', deviceNo: '', streamProtocol: 'rtsp' })
function openBindCamera(row) {
  cameraForm._plotId = row.plotId; cameraForm._plotName = row.plotName; cameraForm.cameraName = ''; cameraForm.deviceNo = ''
  showCamera.value = true
}
const showCameraResult = ref(false)
const cameraResultInfo = reactive({ deviceNo: '', pushUrl: '' })
async function doBindCamera() {
  if (!cameraForm.cameraName) return ElMessage.warning('请填写摄像头名称')
  submitting.value = true
  try {
    const res = await bindCamera(cameraForm._plotId, { cameraName: cameraForm.cameraName, deviceNo: cameraForm.deviceNo || undefined, streamProtocol: cameraForm.streamProtocol })
    showCamera.value = false
    cameraResultInfo.deviceNo = res.deviceNo
    cameraResultInfo.pushUrl = res.rtmpPushUrl
    showCameraResult.value = true
  } catch {} finally { submitting.value = false }
}

// 绑定传感器
const showSensor = ref(false)
const sensorForm = reactive({ _plotId: null, _plotName: '', sensorName: '', deviceNo: '', sensorType: '', category: 'soil', unit: '' })
function openBindSensor(row) {
  sensorForm._plotId = row.plotId; sensorForm._plotName = row.plotName; sensorForm.sensorName = ''; sensorForm.deviceNo = ''; sensorForm.unit = ''; sensorForm.sensorType = ''; sensorForm.category = 'soil'
  showSensor.value = true
}
const showSensorResult = ref(false)
const sensorResultInfo = reactive({ deviceNo: '', topic: '' })
async function doBindSensor() {
  if (!sensorForm.sensorName) return ElMessage.warning('请填写传感器名称')
  if (!sensorForm.sensorType) return ElMessage.warning('请填写传感器类型')
  submitting.value = true
  try {
    const res = await bindSensor(sensorForm._plotId, { sensorName: sensorForm.sensorName, deviceNo: sensorForm.deviceNo || undefined, sensorType: sensorForm.sensorType, category: sensorForm.category, unit: sensorForm.unit })
    showSensor.value = false
    sensorResultInfo.deviceNo = res.deviceNo
    sensorResultInfo.topic = res.mqttTopic
    showSensorResult.value = true
  } catch {} finally { submitting.value = false }
}

// 创建作物批次
const showBatch = ref(false)
const batchForm = reactive({ _plotId: null, _plotName: '', cropName: '', varietyName: '', growthStage: 'seedling', sowingAt: '', expectedHarvestAt: '' })
function openCreateBatch(row) {
  batchForm._plotId = row.plotId; batchForm._plotName = row.plotName; batchForm.cropName = ''; batchForm.varietyName = ''
  showBatch.value = true
}
async function doCreateBatch() {
  if (!batchForm.cropName) return ElMessage.warning('请填写作物名称')
  submitting.value = true
  try { await createCropBatch(batchForm._plotId, { cropName: batchForm.cropName, varietyName: batchForm.varietyName, growthStage: batchForm.growthStage, sowingAt: batchForm.sowingAt || undefined, expectedHarvestAt: batchForm.expectedHarvestAt || undefined }); ElMessage.success('作物批次已创建'); showBatch.value = false } catch {} finally { submitting.value = false }
}

// 绑定大屏
const showScreen = ref(false)
const showScreenToken = ref(false)
const screenTokenResult = ref('')
const screenForm = reactive({ _plotId: null, _plotName: '', screenName: '', deviceNo: '' })
function openBindScreen(row) {
  screenForm._plotId = row.plotId; screenForm._plotName = row.plotName; screenForm.screenName = ''; screenForm.deviceNo = ''
  showScreen.value = true
}
async function doBindScreen() {
  if (!screenForm.screenName) return ElMessage.warning('请填写大屏名称')
  submitting.value = true
  try {
    const res = await bindScreen(screenForm._plotId, { screenName: screenForm.screenName, deviceNo: screenForm.deviceNo || undefined })
    ElMessage.success('大屏已绑定')
    showScreen.value = false
    screenTokenResult.value = res.screenToken
    showScreenToken.value = true
  } catch {} finally { submitting.value = false }
}
function copyText(text) {
  navigator.clipboard.writeText(text)
  ElMessage.success('已复制到剪贴板')
}

// 绑定执行设备
const showActuator = ref(false)
const actuatorForm = reactive({ _plotId: null, _plotName: '', deviceName: '', deviceNo: '', deviceType: 'fertigation_machine' })
function openBindActuator(row) {
  actuatorForm._plotId = row.plotId; actuatorForm._plotName = row.plotName; actuatorForm.deviceName = ''; actuatorForm.deviceNo = ''
  showActuator.value = true
}
async function doBindActuator() {
  if (!actuatorForm.deviceName) return ElMessage.warning('请填写设备名称')
  submitting.value = true
  try { await bindActuator(actuatorForm._plotId, { deviceName: actuatorForm.deviceName, deviceNo: actuatorForm.deviceNo || undefined, deviceType: actuatorForm.deviceType }); ElMessage.success('设备已绑定'); showActuator.value = false; fetchData() } catch {} finally { submitting.value = false }
}
</script>
