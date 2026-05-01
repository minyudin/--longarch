<template>
  <div class="login-page">
    <div class="login-card">
      <div class="login-header">
        <span class="login-logo">🌾</span>
        <h1>{{ platformName }}</h1>
        <p>管理后台 · 开发模式</p>
      </div>

      <div class="account-list">
        <div
          v-for="acc in accounts"
          :key="acc.openId"
          :class="['account-item', { active: selected === acc.openId, loading: loading && selected === acc.openId }]"
          @click="quickLogin(acc.openId)"
        >
          <div class="account-avatar" :style="{ background: acc.color }">
            <el-icon :size="20"><component :is="acc.icon" /></el-icon>
          </div>
          <div class="account-info">
            <span class="account-name">{{ acc.name }}</span>
            <span class="account-role">{{ acc.role }}</span>
          </div>
          <div class="account-arrow">
            <el-icon v-if="!(loading && selected === acc.openId)" :size="14"><ArrowRight /></el-icon>
            <el-icon v-else :size="14" class="spin"><Loading /></el-icon>
          </div>
        </div>
      </div>

      <p class="login-tip">选择账号快速登录（仅开发环境可用）</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import http from '@/api/index'
import { fetchPlatformConfig } from '@/api/admin'
import { ElMessage } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const loading = ref(false)
const selected = ref('')
const platformName = ref('')

onMounted(async () => {
  try {
    const cfg = await fetchPlatformConfig()
    platformName.value = cfg.platformName || ''
  } catch { /* ignore */ }
})

const accounts = [
  { openId: 'admin_openid', name: '张管理', role: '平台管理员', icon: 'Setting', color: 'linear-gradient(135deg, #40ddff, #0b98c5)' },
  { openId: 'operator_openid', name: '李运营', role: '运营人员', icon: 'DataAnalysis', color: 'linear-gradient(135deg, #ff409a, #c438ef)' },
  { openId: 'stub_test_code_001', name: '王认养', role: '认养用户', icon: 'User', color: 'linear-gradient(135deg, #2ecc71, #27ae60)' }
]

async function quickLogin(openId) {
  if (loading.value) return
  selected.value = openId
  loading.value = true
  try {
    const data = await http.post('/auth/dev-login', { openId })
    authStore.setToken(data.token)
    if (data.userInfo) authStore.setUserInfo(data.userInfo)
    ElMessage.success(`已登录：${data.userInfo?.nickname || ''}`)
    router.push('/dashboard')
  } catch (e) {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-gradient);
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    width: 500px;
    height: 500px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(64, 221, 255, 0.08) 0%, transparent 70%);
    top: -100px;
    right: -100px;
  }
  &::after {
    content: '';
    position: absolute;
    width: 400px;
    height: 400px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 64, 154, 0.06) 0%, transparent 70%);
    bottom: -80px;
    left: -80px;
  }
}

.login-card {
  width: 420px;
  background: rgba(49, 47, 98, 0.35);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: 48px 36px 32px;
  box-shadow: var(--shadow-card);
  -webkit-backdrop-filter: blur(20px);
  backdrop-filter: blur(20px);
  position: relative;
  z-index: 1;
}

.login-header {
  text-align: center;
  margin-bottom: 32px;

  .login-logo { font-size: 40px; }

  h1 {
    font-size: 24px;
    margin-top: 12px;
    color: var(--text-white);
    font-weight: 700;
  }

  p {
    font-size: 13px;
    color: var(--text-dim);
    margin-top: 4px;
  }
}

.account-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.account-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 16px;
  border: 1px solid var(--border-color);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;

  &:hover {
    border-color: rgba(64, 221, 255, 0.3);
    background: rgba(64, 221, 255, 0.04);
    transform: translateX(4px);
  }

  &.active {
    border-color: var(--color-primary);
    box-shadow: var(--shadow-glow-cyan);
    background: rgba(64, 221, 255, 0.06);
  }

  &.loading {
    opacity: 0.7;
    pointer-events: none;
  }
}

.account-avatar {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.account-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;

  .account-name {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-white);
  }

  .account-role {
    font-size: 12px;
    color: var(--text-muted);
  }
}

.account-arrow {
  color: var(--text-muted);
  transition: color 0.2s;
}

.login-tip {
  text-align: center;
  font-size: 11px;
  color: var(--text-dim);
  margin-top: 20px;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
.spin { animation: spin 1s linear infinite; }
</style>
