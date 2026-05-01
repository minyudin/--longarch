<template>
  <div>
    <div class="page-header">
      <h2>操作任务</h2>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.taskStatus" placeholder="任务状态" clearable style="width: 140px" @change="fetchData">
        <el-option label="排队中" value="queued" />
        <el-option label="执行中" value="executing" />
        <el-option label="已完成" value="completed" />
        <el-option label="失败" value="failed" />
        <el-option label="已取消" value="cancelled" />
      </el-select>
      <el-button type="primary" @click="fetchData">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="taskId" label="ID" width="60" />
        <el-table-column prop="taskNo" label="任务编号" width="140" />
        <el-table-column prop="requestUserId" label="请求用户" width="100" />
        <el-table-column prop="plotId" label="地块ID" width="80" />
        <el-table-column prop="deviceId" label="设备ID" width="80" />
        <el-table-column prop="actionType" label="动作类型" width="100" />
        <el-table-column prop="priority" label="优先级" width="80" />
        <el-table-column prop="taskStatus" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="{ queued:'warning', executing:'', completed:'success', failed:'danger', cancelled:'info' }[row.taskStatus]" size="small">{{ row.taskStatus }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="doTakeover(row)" :disabled="row.taskStatus === 'completed' || row.taskStatus === 'cancelled'">接管</el-button>
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
import { listTasks, takeoverTask } from '@/api/admin'

const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, taskStatus: '' })

async function fetchData() {
  loading.value = true
  try { const res = await listTasks(query); list.value = res.list; total.value = res.total } catch {} finally { loading.value = false }
}
onMounted(fetchData)

async function doTakeover(row) {
  try {
    await ElMessageBox.confirm(`确定接管任务 ${row.taskNo}？`, '确认接管', { type: 'warning' })
    await takeoverTask(row.taskId, { reason: '管理员接管' })
    ElMessage.success('任务已接管')
    fetchData()
  } catch {}
}
</script>
