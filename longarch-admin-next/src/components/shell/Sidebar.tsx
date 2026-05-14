import { NavLink } from 'react-router-dom'
import './Sidebar.scss'

/**
 * Sidebar · 左侧导航 220px
 * ============================================================
 *  编号 (§1–§10) + 中英标签 + hairline 分隔
 *  源自 museum-folio/src/components/shell/Sidebar.tsx
 *  按 longarch-admin 旧版路由 (去掉 hidden 的 SensorData)
 * ============================================================ */

interface NavItem {
  to: string
  seal: string
  labelCn: string
  labelEn: string
}

const NAV_ITEMS: NavItem[] = [
  { to: '/dashboard',       seal: '§1',  labelCn: '仪表盘',   labelEn: 'Dashboard' },
  { to: '/adoptions/new',   seal: '§+',  labelCn: '新建认养', labelEn: 'New Adoption' },
  { to: '/users',           seal: '§2',  labelCn: '用户',     labelEn: 'Users' },
  { to: '/orders',          seal: '§3',  labelCn: '认养订单', labelEn: 'Orders' },
  { to: '/codes',           seal: '§4',  labelCn: '认养码',   labelEn: 'Codes' },
  { to: '/plots',           seal: '§5',  labelCn: '地块',     labelEn: 'Plots' },
  { to: '/device-overview', seal: '§6',  labelCn: '设备总览', labelEn: 'Devices' },
  { to: '/cameras',         seal: '§7',  labelCn: '摄像头',   labelEn: 'Cameras' },
  { to: '/devices',         seal: '§8',  labelCn: '执行设备', labelEn: 'Actuators' },
  { to: '/screens',         seal: '§9',  labelCn: '大屏',     labelEn: 'Screens' },
  { to: '/tasks',           seal: '§10', labelCn: '操作任务', labelEn: 'Tasks' },
  { to: '/operator-scopes', seal: '§10C', labelCn: '责任域配置', labelEn: 'Operator Scope' },
]

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <header className="sidebar__brand">
        <div className="sidebar__museum-name">
          Longarch
          <span className="sidebar__cn">陇上</span>
        </div>
      </header>

      <nav className="sidebar__nav" aria-label="Chapters">
        {NAV_ITEMS.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `sidebar__link${isActive ? ' sidebar__link--active' : ''}`
            }
          >
            <span className="sidebar__seal">{item.seal}</span>
            <span className="sidebar__label">
              <span className="sidebar__label-cn">{item.labelCn}</span>
              <span className="sidebar__label-en">{item.labelEn}</span>
            </span>
          </NavLink>
        ))}
      </nav>
    </aside>
  )
}
