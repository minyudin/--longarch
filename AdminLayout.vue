<template>
  <div class="layout">
    <!-- 侧边栏 -->
    <aside :class="['sidebar', { collapsed: isCollapse }]">
      <!-- Logo -->
      <div class="sidebar-logo" @click="$router.push('/dashboard')">
        <div class="logo-glow" />
        <span class="logo-emoji">🌾</span>
        <transition name="fade-text">
          <span v-show="!isCollapse" class="logo-brand">
            <strong>{{ platformName }}</strong>
          </span>
        </transition>
      </div>

      <!-- 导航 -->
      <nav class="sidebar-nav">
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          :class="['nav-link', { active: $route.path === item.path }]"
        >
          <!-- 左侧激活指示条 -->
          <transition name="mark">
            <span v-if="$route.path === item.path" class="active-mark" />
          </transition>
          <span :class="['nav-icon', { 'icon-glow': $route.path === item.path }]">
            <el-icon :size="18"><component :is="item.icon" /></el-icon>
          </span>
          <transition name="fade-text">
            <span v-show="!isCollapse" class="nav-text">{{ item.title }}</span>
          </transition>
          <span v-if="item.badge && !isCollapse" class="badge-pill">{{ item.badge }}</span>
        </router-link>
      </nav>

      <!-- 底部折叠按钮 -->
      <div class="sidebar-footer" @click="isCollapse = !isCollapse">
        <el-icon :size="16">
          <Fold v-if="!isCollapse" /><Expand v-else />
        </el-icon>
        <transition name="fade-text">
          <span v-show="!isCollapse" class="footer-text">收起菜单</span>
        </transition>
      </div>
    </aside>

    <!-- 右侧主体 -->
    <div class="main-wrap">
      <!-- 顶栏 -->
      <header class="header">
        <div class="header-left">
          <div class="header-title">
            <h1>{{ $route.meta.title || 'Dashboard' }}</h1>
            <p>{{ platformName }}管理后台</p>
          </div>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand" trigger="click">
            <div class="user-chip">
              <el-avatar :size="26" icon="UserFilled"
                style="background: linear-gradient(135deg, #40ddff, #0b98c5);" />
              <span class="user-name">{{ authStore.userInfo?.nickname || '管理员' }}</span>
              <el-icon :size="10"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">
                  <el-icon><SwitchButton /></el-icon> 退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>

      <!-- 页面内容 -->
      <main class="page-area">
        <router-view v-slot="{ Component }">
          <transition name="page" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { fetchPlatformConfig } from '@/api/admin'

const platformName = ref('')
onMounted(async () => {
  try {
    const cfg = await fetchPlatformConfig()
    platformName.value = cfg.platformName || ''
  } catch { /* ignore */ }
})

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const isCollapse = ref(false)

const menuItems = [
  { path: '/dashboard', title: '仪表盘', icon: 'Odometer' },
  { path: '/users', title: '用户管理', icon: 'User' },
  { path: '/orders', title: '认养订单', icon: 'ShoppingCart' },
  { path: '/codes', title: '认养码', icon: 'Key' },
  { path: '/plots', title: '地块管理', icon: 'MapLocation' },
  { path: '/device-overview', title: '设备总览', icon: 'DataAnalysis' },
  { path: '/cameras', title: '摄像头管理', icon: 'VideoCameraFilled' },
  { path: '/devices', title: '设备管理', icon: 'Monitor' },
  { path: '/screens', title: '大屏管理', icon: 'DataBoard' },
  { path: '/tasks', title: '操作任务', icon: 'List' }
]

function handleCommand(cmd) {
  if (cmd === 'logout') {
    authStore.logout()
    router.push('/login')
  }
}
</script>

<style lang="scss" scoped>
/* ==================== Layout ==================== */
.layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: radial-gradient(ellipse at top right, #201d47, #17153a);
}

/* ==================== Sidebar ==================== */
.sidebar {
  width: 230px;
  background: rgba(26, 23, 64, 0.85);
  -webkit-backdrop-filter: blur(24px);
  backdrop-filter: blur(24px);
  border-right: 1px solid rgba(49, 47, 98, 0.6);
  display: flex;
  flex-direction: column;
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  flex-shrink: 0;
  z-index: 20;

  &.collapsed { width: 68px; }
}

.sidebar-logo {
  height: 64px;
  display: flex;
  align-items: center;
  padding: 0 22px;
  gap: 10px;
  cursor: pointer;
  border-bottom: 1px solid rgba(49, 47, 98, 0.6);
  position: relative;
  overflow: hidden;

  .logo-glow {
    position: absolute;
    width: 80px;
    height: 80px;
    background: radial-gradient(circle, rgba(64, 221, 255, 0.12), transparent 70%);
    top: -20px;
    left: -10px;
    pointer-events: none;
  }

  .logo-emoji { font-size: 24px; position: relative; z-index: 1; }

  .logo-brand {
    font-size: 17px;
    color: #fff;
    white-space: nowrap;
    position: relative;
    z-index: 1;
    strong { font-weight: 700; letter-spacing: 0.5px; }
  }
  .logo-sub {
    color: rgba(255, 255, 255, 0.42);
    font-weight: 400;
  }
}

.sidebar-nav {
  flex: 1;
  padding: 20px 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
  overflow-y: auto;
  overflow-x: hidden;

  &::-webkit-scrollbar { width: 0; }
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 11px 22px;
  margin: 0 10px;
  border-radius: 10px;
  color: #6f6c99;
  text-decoration: none;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.3px;
  transition: all 0.25s ease;
  position: relative;

  &:hover {
    color: #b1afcd;
    background: rgba(64, 221, 255, 0.04);
  }

  &.active {
    color: #40ddff;
    background: rgba(64, 221, 255, 0.08);
  }
}

.active-mark {
  position: absolute;
  left: -10px;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 22px;
  background: #40ddff;
  border-radius: 0 4px 4px 0;
  box-shadow: 0 0 14px 2px rgba(64, 221, 255, 0.45),
              0 0 4px rgba(64, 221, 255, 0.8);
}

.nav-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: rgba(49, 47, 98, 0.45);
  transition: all 0.25s;
  flex-shrink: 0;

  &.icon-glow {
    background: rgba(64, 221, 255, 0.12);
    box-shadow: 0 0 10px rgba(64, 221, 255, 0.2);
  }
}

.nav-text {
  white-space: nowrap;
  overflow: hidden;
}

.badge-pill {
  margin-left: auto;
  background: linear-gradient(135deg, #ff409a, #c438ef);
  color: #fff;
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 10px;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(255, 64, 154, 0.3);
}

.sidebar-footer {
  padding: 16px 22px;
  border-top: 1px solid rgba(49, 47, 98, 0.6);
  display: flex;
  align-items: center;
  gap: 10px;
  color: #5b5a99;
  cursor: pointer;
  font-size: 12px;
  transition: color 0.2s;
  &:hover { color: #b1afcd; }
  .footer-text { white-space: nowrap; }
}

/* ==================== Main ==================== */
.main-wrap {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-width: 0;
}

.header {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  border-bottom: 1px solid rgba(49, 47, 98, 0.6);
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-title {
  h1 {
    font-size: 22px;
    font-weight: 700;
    color: rgba(255, 255, 255, 0.9);
    line-height: 1.2;
  }
  p {
    font-size: 11px;
    color: #5b5a99;
    margin-top: 1px;
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-chip {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px 4px 4px;
  border-radius: 20px;
  border: 1px solid transparent;
  transition: all 0.2s;

  &:hover {
    border-color: rgba(49, 47, 98, 0.8);
    background: rgba(49, 47, 98, 0.3);
  }

  .user-name {
    font-size: 12px;
    color: #5b5a99;
    font-weight: 500;
  }
  .el-icon { color: #5b5a99; }
}

/* ==================== Page ==================== */
.page-area {
  flex: 1;
  overflow-y: auto;
  padding: 28px 32px;

  &::-webkit-scrollbar { width: 6px; }
  &::-webkit-scrollbar-track { background: transparent; }
  &::-webkit-scrollbar-thumb {
    background: rgba(49, 47, 98, 0.6);
    border-radius: 3px;
  }
}

/* ==================== Transitions ==================== */
.page-enter-active { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.page-leave-active { transition: all 0.15s ease-in; }
.page-enter-from { opacity: 0; transform: translateY(12px); }
.page-leave-to { opacity: 0; transform: translateY(-6px); }

.fade-text-enter-active, .fade-text-leave-active {
  transition: opacity 0.2s ease;
}
.fade-text-enter-from, .fade-text-leave-to { opacity: 0; }

.mark-enter-active { transition: all 0.3s ease; }
.mark-leave-active { transition: all 0.15s ease; }
.mark-enter-from { opacity: 0; height: 0; }
.mark-leave-to { opacity: 0; }
</style>
