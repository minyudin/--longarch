<template>
  <div>
    <div class="page-header">
      <h2>大屏管理</h2>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.plotId" placeholder="筛选地块" clearable style="width: 200px" @change="fetchData">
        <el-option v-for="p in plotOptions" :key="p.plotId" :label="p.plotName" :value="p.plotId" />
      </el-select>
      <el-button type="primary" @click="fetchData">刷新</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="screenId" label="ID" width="60" />
        <el-table-column prop="deviceNo" label="设备编号" width="130" />
        <el-table-column prop="screenName" label="大屏名称" width="160" />
        <el-table-column prop="plotName" label="绑定地块" width="140" />
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === 'online' ? 'success' : 'info'" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastPingAt" label="最后心跳" width="170" />
        <el-table-column label="Screen Token" min-width="240">
          <template #default="{ row }">
            <div style="display: flex; align-items: center; gap: 6px;">
              <code style="font-size: 12px; background: #f5f7fa; padding: 2px 6px; border-radius: 3px; word-break: break-all;">{{ row.screenToken }}</code>
              <el-button size="small" link type="primary" @click="copyText(row.screenToken)">复制</el-button>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="warning" link @click="doRegenerate(row)">重新生成Token</el-button>
            <el-popconfirm title="确定删除该大屏？" @confirm="doDelete(row)">
              <template #reference>
                <el-button size="small" type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>

    <!-- 重新生成Token结果 -->
    <el-dialog v-model="showNewToken" title="Token 已重新生成" width="480px">
      <el-alert type="warning" :closable="false" show-icon>
        <template #title>旧 Token 已失效，请将新 Token 配置到大屏浏览器</template>
      </el-alert>
      <div style="margin-top: 16px; padding: 12px; background: #f5f7fa; border-radius: 4px; font-family: monospace; word-break: break-all;">
        {{ newTokenValue }}
      </div>
      <div style="margin-top: 8px; color: #909399; font-size: 12px;">大屏访问地址示例：http://大屏地址/?token={{ newTokenValue }}</div>
      <template #footer>
        <el-button type="primary" @click="copyText(newTokenValue)">复制 Token</el-button>
        <el-button @click="showNewToken = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listScreens, deleteScreen, regenerateScreenToken, listPlots } from '@/api/admin'

const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, plotId: null })
const plotOptions = ref([])

async function fetchPlotOptions() {
  try {
    const res = await listPlots({ pageNo: 1, pageSize: 100 })
    plotOptions.value = res.list || []
  } catch {}
}

async function fetchData() {
  loading.value = true
  try {
    const params = { pageNo: query.pageNo, pageSize: query.pageSize }
    if (query.plotId) params.plotId = query.plotId
    const res = await listScreens(params)
    list.value = res.list
    total.value = res.total
  } catch {} finally { loading.value = false }
}

onMounted(() => { fetchPlotOptions(); fetchData() })

// 删除
async function doDelete(row) {
  try {
    await deleteScreen(row.screenId)
    ElMessage.success('大屏已删除')
    fetchData()
  } catch {}
}

// 重新生成Token
const showNewToken = ref(false)
const newTokenValue = ref('')
async function doRegenerate(row) {
  try {
    const res = await regenerateScreenToken(row.screenId)
    newTokenValue.value = res.screenToken
    showNewToken.value = true
    fetchData()
  } catch {}
}

function copyText(text) {
  navigator.clipboard.writeText(text)
  ElMessage.success('已复制到剪贴板')
}
</script>
