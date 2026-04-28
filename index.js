import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('@/layout/AdminLayout.vue'),
    meta: { requiresAuth: true },
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '仪表盘', icon: 'Odometer' }
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('@/views/Users.vue'),
        meta: { title: '用户管理', icon: 'User' }
      },
      {
        path: 'orders',
        name: 'Orders',
        component: () => import('@/views/Orders.vue'),
        meta: { title: '认养订单', icon: 'ShoppingCart' }
      },
      {
        path: 'codes',
        name: 'Codes',
        component: () => import('@/views/Codes.vue'),
        meta: { title: '认养码', icon: 'Key' }
      },
      {
        path: 'plots',
        name: 'Plots',
        component: () => import('@/views/Plots.vue'),
        meta: { title: '地块管理', icon: 'MapLocation' }
      },
      {
        path: 'screens',
        name: 'Screens',
        component: () => import('@/views/Screens.vue'),
        meta: { title: '大屏管理', icon: 'DataBoard' }
      },
      {
        path: 'device-overview',
        name: 'DeviceOverview',
        component: () => import('@/views/DeviceOverview.vue'),
        meta: { title: '设备总览', icon: 'DataAnalysis' }
      },
      {
        path: 'sensor-data',
        name: 'SensorData',
        component: () => import('@/views/SensorData.vue'),
        meta: { title: '传感器数据', icon: 'TrendCharts', hidden: true }
      },
      {
        path: 'cameras',
        name: 'CameraManagement',
        component: () => import('@/views/CameraManagement.vue'),
        meta: { title: '摄像头管理', icon: 'VideoCameraFilled' }
      },
      {
        path: 'devices',
        name: 'Devices',
        component: () => import('@/views/Devices.vue'),
        meta: { title: '设备管理', icon: 'Monitor' }
      },
      {
        path: 'tasks',
        name: 'Tasks',
        component: () => import('@/views/Tasks.vue'),
        meta: { title: '操作任务', icon: 'List' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()
  if (to.meta.requiresAuth !== false && !authStore.token) {
    next('/login')
  } else {
    next()
  }
})

export default router
