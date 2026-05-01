<template>
  <div>
    <div class="page-header">
      <h2>用户管理</h2>
      <el-button type="primary" @click="showCreate = true">
        <el-icon><Plus /></el-icon> 新建用户
      </el-button>
    </div>

    <div class="filter-bar">
      <el-select v-model="query.roleType" placeholder="角色筛选" clearable style="width: 140px" @change="fetchData">
        <el-option label="管理员" value="admin" />
        <el-option label="认养用户" value="adopter" />
        <el-option label="运营人员" value="operator" />
        <el-option label="农技人员" value="agronomist" />
      </el-select>
      <el-input v-model="query.keyword" placeholder="搜索昵称/姓名/手机号" clearable style="width: 240px" @keyup.enter="fetchData" />
      <el-button type="primary" @click="fetchData">搜索</el-button>
    </div>

    <div class="table-card">
      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="userId" label="ID" width="70" />
        <el-table-column prop="userNo" label="用户编号" width="120" />
        <el-table-column prop="nickname" label="昵称" />
        <el-table-column prop="realName" label="真实姓名" />
        <el-table-column prop="mobile" label="手机号" width="130" />
        <el-table-column prop="roleType" label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="roleTag(row.roleType)" size="small">{{ roleLabel(row.roleType) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="170" />
      </el-table>
      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="query.pageNo"
          v-model:page-size="query.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @size-change="fetchData"
          @current-change="fetchData"
        />
      </div>
    </div>

    <!-- 新建用户弹窗 -->
    <el-dialog v-model="showCreate" title="新建用户" width="480px" destroy-on-close>
      <el-form :model="createForm" :rules="createRules" ref="createRef" label-width="80px">
        <el-form-item label="OpenID" prop="openId">
          <el-input v-model="createForm.openId" />
        </el-form-item>
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="createForm.nickname" />
        </el-form-item>
        <el-form-item label="角色" prop="roleType">
          <el-select v-model="createForm.roleType" style="width: 100%">
            <el-option label="管理员" value="admin" />
            <el-option label="认养用户" value="adopter" />
            <el-option label="运营人员" value="operator" />
            <el-option label="农技人员" value="agronomist" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreate = false">取消</el-button>
        <el-button type="primary" :loading="creating" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { listUsers, createUser } from '@/api/admin'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ pageNo: 1, pageSize: 10, roleType: '', keyword: '' })

const showCreate = ref(false)
const creating = ref(false)
const createRef = ref()
const createForm = reactive({ openId: '', nickname: '', roleType: 'adopter' })
const createRules = {
  openId: [{ required: true, message: '请输入 OpenID', trigger: 'blur' }],
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  roleType: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

function roleLabel(r) {
  return { admin: '管理员', adopter: '认养用户', operator: '运营人员', agronomist: '农技人员' }[r] || r
}
function roleTag(r) {
  return { admin: 'danger', adopter: '', operator: 'warning', agronomist: 'success' }[r] || 'info'
}

async function fetchData() {
  loading.value = true
  try {
    const res = await listUsers(query)
    list.value = res.list
    total.value = res.total
  } catch { /* handled */ } finally {
    loading.value = false
  }
}

async function handleCreate() {
  await createRef.value.validate()
  creating.value = true
  try {
    await createUser(createForm)
    ElMessage.success('创建成功')
    showCreate.value = false
    fetchData()
  } catch { /* handled */ } finally {
    creating.value = false
  }
}

onMounted(fetchData)
</script>
