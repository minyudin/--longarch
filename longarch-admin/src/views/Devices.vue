<template>
  <div>
    <div class="page-header">
      <h2>设备管理</h2>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.deviceStatus" placeholder="设备状态" clearable style="width: 140px" @change="fetchData">
        <el-option label="在线" value="online" />
        <el-option label="离线" value="offline" />
      </el-select>
      <el-button type="primary" @click="fetchData">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="deviceId" label="ID" width="60" />
        <el-table-column prop="deviceNo" label="设备编号" width="140" />
        <el-table-column prop="deviceName" label="设备名称" />
        <el-table-column prop="plotId" label="地块ID" width="80" />
        <el-table-column prop="deviceType" label="类型" width="100" />
        <el-table-column prop="deviceStatus" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.deviceStatus==='online' ? 'success' : 'danger'" size="small">{{ row.deviceStatus }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lockStatus" label="锁状态" width="90" />
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="warning" link @click="doUnlock(row)">解锁</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listDevices, unlockDevice } from '@/api/admin'

const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, deviceStatus: '' })

async function fetchData() {
  loading.value = true
  try { const res = await listDevices(query); list.value = res.list; total.value = res.total } catch {} finally { loading.value = false }
}
onMounted(fetchData)

async function doUnlock(row) {
  try {
    await ElMessageBox.confirm(`确定强制解锁设备 ${row.deviceName}？`, '确认解锁', { type: 'warning' })
    await unlockDevice(row.deviceId, { reason: '管理员强制解锁' })
    ElMessage.success('设备已解锁')
    fetchData()
  } catch {}
}
</script>
