<template>
  <div>
    <div class="page-header">
      <h2>认养订单</h2>
      <el-button type="primary" @click="showCreate = true"><el-icon><Plus /></el-icon> 新建订单</el-button>
    </div>
    <div class="filter-bar">
      <el-select v-model="query.orderStatus" placeholder="订单状态" clearable style="width: 140px" @change="fetchData">
        <el-option label="待处理" value="pending" />
        <el-option label="进行中" value="active" />
        <el-option label="已完成" value="completed" />
        <el-option label="已取消" value="cancelled" />
      </el-select>
      <el-button type="primary" @click="fetchData">筛选</el-button>
    </div>
    <div class="table-card">
      <el-table :data="list" v-loading="loading">
        <el-table-column prop="orderId" label="ID" width="60" />
        <el-table-column prop="orderNo" label="订单号" width="140" />
        <el-table-column prop="userId" label="用户ID" width="80" />
        <el-table-column prop="adoptionType" label="类型" width="90" />
        <el-table-column prop="orderStatus" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="{ pending:'warning', active:'', completed:'success', cancelled:'info' }[row.orderStatus]" size="small">{{ row.orderStatus }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="payableAmount" label="金额" width="90" />
        <el-table-column prop="createdAt" label="创建时间" width="170" />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="openStatusDlg(row)">变更状态</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap">
        <el-pagination v-model:current-page="query.pageNo" v-model:page-size="query.pageSize" :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next" @size-change="fetchData" @current-change="fetchData" />
      </div>
    </div>

    <!-- 新建订单 -->
    <el-dialog v-model="showCreate" title="新建认养订单" width="480px" destroy-on-close>
      <el-form :model="createForm" label-width="80px">
        <el-form-item label="地块ID" required><el-input-number v-model="createForm.plotId" :min="1" /></el-form-item>
        <el-form-item label="用户ID"><el-input-number v-model="createForm.userId" :min="1" /></el-form-item>
        <el-form-item label="开始时间" required><el-date-picker v-model="createForm.startAt" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
        <el-form-item label="结束时间" required><el-date-picker v-model="createForm.endAt" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item>
        <el-form-item label="金额"><el-input-number v-model="createForm.payableAmount" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="createForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreate = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doCreate">提交</el-button>
      </template>
    </el-dialog>

    <!-- 变更状态 -->
    <el-dialog v-model="showStatus" title="变更订单状态" width="400px" destroy-on-close>
      <el-form :model="statusForm" label-width="80px">
        <el-form-item label="当前状态"><el-tag>{{ statusForm._current }}</el-tag></el-form-item>
        <el-form-item label="新状态" required>
          <el-select v-model="statusForm.orderStatus" style="width: 100%">
            <el-option label="待处理" value="pending" />
            <el-option label="进行中" value="active" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注"><el-input v-model="statusForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showStatus = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="doUpdateStatus">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listOrders, createOrder, updateOrderStatus } from '@/api/admin'

const loading = ref(false)
const submitting = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, orderStatus: '' })

async function fetchData() {
  loading.value = true
  try { const res = await listOrders(query); list.value = res.list; total.value = res.total } catch {} finally { loading.value = false }
}
onMounted(fetchData)

// 新建
const showCreate = ref(false)
const createForm = reactive({ plotId: null, userId: null, startAt: '', endAt: '', payableAmount: null, remark: '' })
async function doCreate() {
  if (!createForm.plotId || !createForm.startAt || !createForm.endAt) return ElMessage.warning('请填写必填项')
  submitting.value = true
  try { await createOrder(createForm); ElMessage.success('创建成功'); showCreate.value = false; fetchData() } catch {} finally { submitting.value = false }
}

// 变更状态
const showStatus = ref(false)
const statusForm = reactive({ _id: null, _current: '', orderStatus: '', remark: '' })
function openStatusDlg(row) {
  statusForm._id = row.orderId; statusForm._current = row.orderStatus; statusForm.orderStatus = ''; statusForm.remark = ''
  showStatus.value = true
}
async function doUpdateStatus() {
  if (!statusForm.orderStatus) return ElMessage.warning('请选择新状态')
  submitting.value = true
  try { await updateOrderStatus(statusForm._id, { orderStatus: statusForm.orderStatus, remark: statusForm.remark }); ElMessage.success('状态已更新'); showStatus.value = false; fetchData() } catch {} finally { submitting.value = false }
}
</script>
