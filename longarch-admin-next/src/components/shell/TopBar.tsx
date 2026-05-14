import { useRef, useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useAuthStore } from '@/stores/auth'
import { fetchPlatformConfig, logout as logoutApi } from '@/api'
import { qk } from '@/lib/queryKeys'
import { STALE } from '@/lib/queryClient'
import { useGsapButton } from '@/lib/useGsapButton'
import './TopBar.scss'

/**
 * TopBar · 顶栏 52px
 * ============================================================
 *  左: 当前路由章节编号 (§N) + 平台名
 *  右: 用户信息 chip + 登出按钮
 * ============================================================ */

const ROUTE_TITLES: Record<string, { seal: string; cn: string; en: string }> = {
  '/dashboard':       { seal: '§1',  cn: '仪表盘',   en: 'Dashboard' },
  '/users':           { seal: '§2',  cn: '用户',     en: 'Users' },
  '/orders':          { seal: '§3',  cn: '认养订单', en: 'Orders' },
  '/codes':           { seal: '§4',  cn: '认养码',   en: 'Codes' },
  '/plots':           { seal: '§5',  cn: '地块',     en: 'Plots' },
  '/device-overview': { seal: '§6',  cn: '设备总览', en: 'Devices' },
  '/cameras':         { seal: '§7',  cn: '摄像头',   en: 'Cameras' },
  '/devices':         { seal: '§8',  cn: '执行设备', en: 'Actuators' },
  '/screens':         { seal: '§9',  cn: '大屏',     en: 'Screens' },
  '/tasks':           { seal: '§10', cn: '操作任务', en: 'Tasks' },
  '/operator-scopes': { seal: '§10C', cn: '责任域配置', en: 'Operator Scope' },
  '/sensor-data':     { seal: '§11', cn: '传感器数据', en: 'Sensor Data' },
}

export default function TopBar() {
  const navigate = useNavigate()
  const location = useLocation()
  const queryClient = useQueryClient()
  const userInfo = useAuthStore((s) => s.userInfo)
  const clearStore = useAuthStore((s) => s.logout)
  const [loggingOut, setLoggingOut] = useState(false)
  const logoutRef = useRef<HTMLButtonElement | null>(null)

  // 平台配置 · 一次性元数据 · 永不过期
  const { data: cfg } = useQuery({
    queryKey: qk.platformConfig(),
    queryFn: fetchPlatformConfig,
    staleTime: STALE.STATIC,
    retry: false,
  })
  const platformName = cfg?.platformName ?? ''

  const route = ROUTE_TITLES[location.pathname]
  useGsapButton(logoutRef, { disabled: loggingOut })

  // 登出流程 (cookie-first):
  //  1) 调 POST /auth/logout → 后端清 session + Set-Cookie 擦 satoken cookie
  //  2) 即使后端失败也本地清 store + query cache, 保证前端呈"已登出"态
  //  3) 跳 /login
  async function handleLogout() {
    if (loggingOut) return
    setLoggingOut(true)
    try {
      await logoutApi()
    } catch {
      // 网络异常或 session 已过期, 走本地清理即可
    } finally {
      clearStore()
      queryClient.clear()
      navigate('/login')
      setLoggingOut(false)
    }
  }

  return (
    <header className="topbar">
      <div className="topbar__left">
        {route && (
          <>
            <span className="topbar__seal">{route.seal}</span>
            <span className="topbar__sep">·</span>
            <span className="topbar__title-cn">{route.cn}</span>
            <span className="topbar__title-en">{route.en}</span>
          </>
        )}
      </div>
      <div className="topbar__right">
        {platformName && <span className="topbar__platform">{platformName}</span>}
        {userInfo && (
          <div className="topbar__user">
            <span className="topbar__user-role">
              {userInfo.roleProfile?.roleName || userInfo.roleType || 'Guest'}
            </span>
            <span className="topbar__user-name">
              {userInfo.nickname || userInfo.userNo || '—'}
            </span>
          </div>
        )}
        <button ref={logoutRef} type="button" className="topbar__logout" onClick={handleLogout}>
          登出 <em>Sign out</em>
        </button>
      </div>
    </header>
  )
}
