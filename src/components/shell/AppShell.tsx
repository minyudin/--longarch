import { Outlet } from 'react-router-dom'
import Sidebar from './Sidebar'
import TopBar from './TopBar'
import './AppShell.scss'

/**
 * AppShell · 主外壳布局 (Cookie-First 重构 · 2026-04)
 * ============================================================
 *  Sidebar (左 220px) + TopBar (上 52px) + Main (Outlet)
 *  登录页 /login 不套此壳, 由 router 直接渲染 LoginPage
 *
 *  启动引导 (/users/me 探测) 已上移到 <AuthBootstrap>, 这里只负责布局
 *  只有 RouteGuard 放行后 (bootstrapped=true + userInfo 存在) AppShell 才会 mount
 * ============================================================ */
export default function AppShell() {
  return (
    <div className="folio-app">
      <Sidebar />
      <TopBar />
      <main className="folio-app__main">
        <Outlet />
      </main>
    </div>
  )
}
