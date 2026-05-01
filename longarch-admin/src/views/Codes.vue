<template>
  <div>
    <div class="page-header">
      <h2>认养码</h2>
      <el-button type="primary" @click="showCreate = true"><el-icon><Plus /></el-icon> 生成认养码</el-button>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 120px" @change="fetchData">
        <el-option label="激活" value="active" />
        <el-option label="已使用" value="used" />
        <el-option label="已吊销" value="revoked" />
      </el-select>
      <el-button type="primary" @click="fetchData">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="codeId" label="ID" width="60" />
        <el-table-column prop="code" label="认养码" width="200" />
        <el-table-column prop="codeType" label="类型" width="90" />
        <el-table-column prop="orderId" label="订单ID" width="80" />
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="{ active:'success', used:'info', revoked:'danger' }[row.status]" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="danger" link :disabled="row.status==='revoked'" @click="doRevoke(row)">吊销</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>

    <!-- 生成认养码 -->
    <el-dialog v-model="showCreate" title="生成认养码" width="440px" destroy-on-close>
      <el-form :model="createForm" label-width="80px">
        <el-form-item label="订单ID" required><el-input-number v-model="createForm.orderId" :min="1" /></el-form-item>
        <el-form-item label="码类型">
          <el-select v-model="createForm.codeType" style="width: 100%">
            <el-option label="主码 master" value="master" />
            <el-option label="访客码 guest" value="guest" />
            <el-option label="分享码 share" value="share" />
          </el-select>
        </el-form-item>
        <el-form-item label="有效开始" required><el-date-picker v-model="createForm.validFrom" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
        <el-form-item label="有效结束" required><el-date-picker v-model="createForm.validTo" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreate = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doCreateCode">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCodes, createCode, revokeCode } from '@/api/admin'

const loading = ref(false)
const submitting = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, status: '' })

async function fetchData() {
  loading.value = true
  try { const res = await listCodes(query); list.value = res.list; total.value = res.total } catch {} finally { loading.value = false }
}
onMounted(fetchData)

// 生成
const showCreate = ref(false)
const createForm = reactive({ orderId: null, codeType: 'master', validFrom: '', validTo: '' })
async function doCreateCode() {
  if (!createForm.orderId || !createForm.validFrom || !createForm.validTo) return ElMessage.warning('请填写必填项')
  submitting.value = true
  try { await createCode(createForm); ElMessage.success('认养码已生成'); showCreate.value = false; fetchData() } catch {} finally { submitting.value = false }
}

// 吊销
async function doRevoke(row) {
  try {
    await ElMessageBox.confirm(`确定吊销认养码 ${row.code}？`, '确认吊销', { type: 'warning' })
    await revokeCode(row.codeId, { reason: '管理员手动吊销' })
    ElMessage.success('已吊销')
    fetchData()
  } catch {}
}
</script>
