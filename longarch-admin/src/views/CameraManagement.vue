<template>
  <div>
    <div class="page-header">
      <h2>摄像头管理</h2>
      <el-button type="primary" @click="fetchCameras">刷新</el-button>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-select v-model="query.plotId" placeholder="筛选地块" clearable style="width: 180px" @change="fetchCameras">
        <el-option v-for="p in plotOptions" :key="p.plotId" :label="p.plotName" :value="p.plotId" />
      </el-select>
      <el-select v-model="query.networkStatus" placeholder="网络状态" clearable style="width: 140px" @change="fetchCameras">
        <el-option label="在线" value="online" />
        <el-option label="离线" value="offline" />
      </el-select>
      <el-button type="primary" @click="fetchCameras">筛选</el-button>
    </div>

    <!-- 摄像头表格 -->
    <div class="table-card">
      <el-table :data="cameraList" v-loading="loading">
        <el-table-column prop="cameraId" label="ID" width="60" />
        <el-table-column prop="deviceNo" label="设备编号" width="130" />
        <el-table-column prop="cameraName" label="名称" width="160" />
        <el-table-column prop="plotName" label="所属地块" width="120" />
        <el-table-column prop="networkStatus" label="网络" width="80">
          <template #default="{ row }">
            <el-tag :type="row.networkStatus === 'online' ? 'success' : 'danger'" size="small">
              {{ row.networkStatus === 'online' ? '在线' : '离线' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="推流" width="80">
          <template #default="{ row }">
            <el-tag :type="row.streaming ? 'success' : 'info'" size="small" :effect="row.streaming ? 'dark' : 'plain'">
              {{ row.streaming ? '推流中' : '未推流' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="deviceStatus" label="设备状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.deviceStatus === 'online' ? 'success' : row.deviceStatus === 'registered' ? 'info' : 'warning'" size="small">
              {{ row.deviceStatus }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="streamProtocol" label="协议" width="70" />
        <el-table-column label="功能" width="120">
          <template #default="{ row }">
            <el-tag v-if="row.ptzEnabled" type="warning" size="small" style="margin-right: 4px;">云台</el-tag>
            <el-tag v-if="row.playbackEnabled" type="info" size="small">回放</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="openPreview(row)">预览</el-button>
            <el-button size="small" type="warning" link @click="openEdit(row)">编辑</el-button>
            <el-button size="small" type="info" link @click="showDetail(row)">详情</el-button>
            <el-popconfirm title="确认删除该摄像头？" @confirm="handleDelete(row)">
              <template #reference>
                <el-button size="small" type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="query.pageNo"
          v-model:page-size="query.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @size-change="fetchCameras"
          @current-change="fetchCameras"
        />
      </div>
    </div>

    <!-- 预览弹窗 -->
    <el-dialog v-model="previewVisible" :title="'预览 - ' + previewCamera.cameraName" width="720px" destroy-on-close>
      <div style="margin-bottom: 12px;">
        <el-tag type="success" size="small" style="margin-right: 8px;">{{ previewCamera.deviceNo }}</el-tag>
        <el-tag :type="previewCamera.networkStatus === 'online' ? 'success' : 'danger'" size="small" style="margin-right: 8px;">
          {{ previewCamera.networkStatus === 'online' ? '在线' : '离线' }}
        </el-tag>
        <el-tag :type="previewCamera.streaming ? 'success' : 'info'" size="small" :effect="previewCamera.streaming ? 'dark' : 'plain'">
          {{ previewCamera.streaming ? '推流中' : '未推流' }}
        </el-tag>
      </div>

      <el-tabs v-model="previewTab">
        <el-tab-pane label="FLV 直播" name="flv">
          <div class="stream-info">
            <span class="stream-label">FLV 地址：</span>
            <el-input :model-value="previewCamera.flvPlayUrl" readonly size="small" style="flex: 1;">
              <template #append>
                <el-button @click="copyUrl(previewCamera.flvPlayUrl)">复制</el-button>
              </template>
            </el-input>
          </div>
          <div class="player-placeholder">
            <el-icon size="48" color="#c0c4cc"><VideoCamera /></el-icon>
            <p>请使用 FLV 播放器（如 flv.js）接入上方地址</p>
            <p style="font-size: 12px; color: #c0c4cc;">实际推流后可在此处集成播放器组件</p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="HLS 直播" name="hls">
          <div class="stream-info">
            <span class="stream-label">HLS 地址：</span>
            <el-input :model-value="previewCamera.hlsPlayUrl" readonly size="small" style="flex: 1;">
              <template #append>
                <el-button @click="copyUrl(previewCamera.hlsPlayUrl)">复制</el-button>
              </template>
            </el-input>
          </div>
          <div class="player-placeholder">
            <el-icon size="48" color="#c0c4cc"><VideoCamera /></el-icon>
            <p>请使用 HLS 播放器（如 hls.js）接入上方地址</p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="推流信息" name="push">
          <el-descriptions :column="1" border size="small">
            <el-descriptions-item label="RTMP 推流地址">{{ previewCamera.rtmpPushUrl || '未配置' }}</el-descriptions-item>
            <el-descriptions-item label="Stream App">{{ previewCamera.streamApp }}</el-descriptions-item>
            <el-descriptions-item label="Stream Name">{{ previewCamera.streamName }}</el-descriptions-item>
            <el-descriptions-item label="协议">{{ previewCamera.streamProtocol }}</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>

    <!-- 编辑弹窗 -->
    <el-dialog v-model="editVisible" title="编辑摄像头" width="520px">
      <el-form :model="editForm" label-width="100px">
        <el-form-item label="设备编号">
          <el-input :model-value="editForm.deviceNo" disabled />
        </el-form-item>
        <el-form-item label="名称">
          <el-input v-model="editForm.cameraName" />
        </el-form-item>
        <el-form-item label="推流协议">
          <el-select v-model="editForm.streamProtocol" style="width: 100%;">
            <el-option label="RTMP" value="rtmp" />
            <el-option label="WebRTC" value="webrtc" />
          </el-select>
        </el-form-item>
        <el-form-item label="Stream App">
          <el-input v-model="editForm.streamApp" />
        </el-form-item>
        <el-form-item label="Stream Name">
          <el-input v-model="editForm.streamName" />
        </el-form-item>
        <el-form-item label="推流地址">
          <el-input v-model="editForm.rtmpPushUrl" />
        </el-form-item>
        <el-form-item label="云台控制">
          <el-switch v-model="editForm.ptzEnabled" />
        </el-form-item>
        <el-form-item label="支持回放">
          <el-switch v-model="editForm.playbackEnabled" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editVisible = false">取消</el-button>
        <el-button type="primary" :loading="editLoading" @click="handleUpdate">保存</el-button>
      </template>
    </el-dialog>

    <!-- 详情弹窗 -->
    <el-dialog v-model="detailVisible" title="摄像头详情" width="560px">
      <el-descriptions :column="2" border size="small">
        <el-descriptions-item label="ID">{{ detailCamera.cameraId }}</el-descriptions-item>
        <el-descriptions-item label="设备编号">{{ detailCamera.deviceNo }}</el-descriptions-item>
        <el-descriptions-item label="名称">{{ detailCamera.cameraName }}</el-descriptions-item>
        <el-descriptions-item label="所属地块">{{ detailCamera.plotName }}</el-descriptions-item>
        <el-descriptions-item label="网络状态">
          <el-tag :type="detailCamera.networkStatus === 'online' ? 'success' : 'danger'" size="small">{{ detailCamera.networkStatus }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="设备状态">{{ detailCamera.deviceStatus }}</el-descriptions-item>
        <el-descriptions-item label="推流状态">
          <el-tag :type="detailCamera.streaming ? 'success' : 'info'" size="small" :effect="detailCamera.streaming ? 'dark' : 'plain'">{{ detailCamera.streaming ? '推流中' : '未推流' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="推流协议">{{ detailCamera.streamProtocol }}</el-descriptions-item>
        <el-descriptions-item label="Stream App">{{ detailCamera.streamApp }}</el-descriptions-item>
        <el-descriptions-item label="Stream Name">{{ detailCamera.streamName }}</el-descriptions-item>
        <el-descriptions-item label="云台">{{ detailCamera.ptzEnabled ? '支持' : '不支持' }}</el-descriptions-item>
        <el-descriptions-item label="回放">{{ detailCamera.playbackEnabled ? '支持' : '不支持' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detailCamera.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="RTMP 推流地址" :span="2">{{ detailCamera.rtmpPushUrl || '未配置' }}</el-descriptions-item>
        <el-descriptions-item label="FLV 播放地址" :span="2">{{ detailCamera.flvPlayUrl }}</el-descriptions-item>
        <el-descriptions-item label="HLS 播放地址" :span="2">{{ detailCamera.hlsPlayUrl }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { VideoCamera } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { listCameras, updateCamera, deleteCamera, listPlots } from '@/api/admin'

const loading = ref(false)
const cameraList = ref([])
const total = ref(0)
const plotOptions = ref([])
const query = reactive({ pageNo: 1, pageSize: 10, plotId: null, networkStatus: '' })

// 预览
const previewVisible = ref(false)
const previewCamera = reactive({})
const previewTab = ref('flv')

// 编辑
const editVisible = ref(false)
const editLoading = ref(false)
const editForm = reactive({
  cameraId: null,
  deviceNo: '',
  cameraName: '',
  streamProtocol: '',
  streamApp: '',
  streamName: '',
  rtmpPushUrl: '',
  ptzEnabled: false,
  playbackEnabled: false
})

// 详情
const detailVisible = ref(false)
const detailCamera = reactive({})

async function fetchCameras() {
  loading.value = true
  try {
    const params = { pageNo: query.pageNo, pageSize: query.pageSize }
    if (query.plotId) params.plotId = query.plotId
    if (query.networkStatus) params.networkStatus = query.networkStatus
    const res = await listCameras(params)
    cameraList.value = res.list
    total.value = res.total
  } catch {} finally { loading.value = false }
}

async function fetchPlotOptions() {
  try {
    const res = await listPlots({ pageNo: 1, pageSize: 100 })
    plotOptions.value = res.list || []
  } catch {}
}

function openPreview(row) {
  Object.assign(previewCamera, row)
  previewTab.value = 'flv'
  previewVisible.value = true
}

function openEdit(row) {
  editForm.cameraId = row.cameraId
  editForm.deviceNo = row.deviceNo
  editForm.cameraName = row.cameraName
  editForm.streamProtocol = row.streamProtocol
  editForm.streamApp = row.streamApp
  editForm.streamName = row.streamName
  editForm.rtmpPushUrl = row.rtmpPushUrl
  editForm.ptzEnabled = row.ptzEnabled
  editForm.playbackEnabled = row.playbackEnabled
  editVisible.value = true
}

async function handleUpdate() {
  editLoading.value = true
  try {
    await updateCamera(editForm.cameraId, {
      cameraName: editForm.cameraName,
      streamProtocol: editForm.streamProtocol,
      streamApp: editForm.streamApp,
      streamName: editForm.streamName,
      rtmpPushUrl: editForm.rtmpPushUrl,
      ptzEnabled: editForm.ptzEnabled,
      playbackEnabled: editForm.playbackEnabled
    })
    ElMessage.success('更新成功')
    editVisible.value = false
    fetchCameras()
  } catch {} finally { editLoading.value = false }
}

async function handleDelete(row) {
  try {
    await deleteCamera(row.cameraId)
    ElMessage.success('删除成功')
    fetchCameras()
  } catch {}
}

function showDetail(row) {
  Object.assign(detailCamera, row)
  detailVisible.value = true
}

function copyUrl(url) {
  navigator.clipboard.writeText(url).then(() => {
    ElMessage.success('已复制到剪贴板')
  }).catch(() => {
    ElMessage.warning('复制失败，请手动复制')
  })
}

onMounted(() => { fetchCameras(); fetchPlotOptions() })
</script>

<style scoped>
.stream-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}
.stream-label {
  font-size: 13px;
  color: #606266;
  white-space: nowrap;
}
.player-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
  background: #1a1a2e;
  border-radius: 8px;
  color: #909399;
}
.player-placeholder p {
  margin-top: 12px;
  font-size: 14px;
}
</style>
