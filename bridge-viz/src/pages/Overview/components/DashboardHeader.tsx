interface Props {
  greenhouseName: string;
  farmName: string;
  updatedAt: string;
  cameraStatus: string | null;
  /** 活跃点位数 */
  plotCount?: number;
  /** 有数据的点位数 */
  activePlots?: number;
  /** 环境指标数 */
  envMetrics?: number;
}

/**
 * DashboardHeader — 大屏顶栏
 *
 * 显示：农场名 · 大棚名 · 数据更新时间 · 摄像头在线状态 · 快捷指标
 */
export default function DashboardHeader({
  greenhouseName,
  farmName,
  updatedAt,
  cameraStatus,
  plotCount = 0,
  activePlots = 0,
  envMetrics = 0,
}: Props) {
  const isOnline = cameraStatus === "online";

  return (
    <header className="dash-hdr">
      {/* 底部装饰线 */}
      <div className="dash-hdr__line" />

      {/* 左侧：标题 */}
      <div className="dash-hdr__left">
        <span className="dash-hdr__num">01</span>
        <h1 className="dash-hdr__title">
          <span className="gradient-text">{farmName}</span>
          <span className="dash-hdr__sep">/</span>
          <span>{greenhouseName}</span>
        </h1>
      </div>

      {/* 中间：快捷统计 */}
      <div className="dash-hdr__stats">
        <div className="dash-hdr__stat">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <rect x="3" y="3" width="7" height="7" /><rect x="14" y="3" width="7" height="7" />
            <rect x="3" y="14" width="7" height="7" /><rect x="14" y="14" width="7" height="7" />
          </svg>
          <span className="dash-hdr__stat-value">{plotCount}</span>
          <span className="dash-hdr__stat-label">PLOTS</span>
        </div>
        <span className="dash-hdr__divider" />
        <div className="dash-hdr__stat">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
          </svg>
          <span className="dash-hdr__stat-value">{activePlots}</span>
          <span className="dash-hdr__stat-label">ACTIVE</span>
        </div>
        <span className="dash-hdr__divider" />
        <div className="dash-hdr__stat">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z" />
          </svg>
          <span className="dash-hdr__stat-value">{envMetrics}</span>
          <span className="dash-hdr__stat-label">ENV</span>
        </div>
        <span className="dash-hdr__divider" />
        <div className="dash-hdr__stat">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <path d="M5 12.55a11 11 0 0 1 14.08 0" /><path d="M1.42 9a16 16 0 0 1 21.16 0" />
            <path d="M8.53 16.11a6 6 0 0 1 6.95 0" /><circle cx="12" cy="20" r="1" fill="currentColor" />
          </svg>
          <span className="dash-hdr__stat-value dash-hdr__stat-value--accent">
            {isOnline ? "OK" : "--"}
          </span>
          <span className="dash-hdr__stat-label">LINK</span>
        </div>
      </div>

      {/* 右侧：状态 + 时间 */}
      <div className="dash-hdr__right">
        <span className={`dash-hdr__status ${isOnline ? "dash-hdr__status--on" : "dash-hdr__status--off"}`}>
          <span className="dash-hdr__dot" />
          {isOnline ? "ONLINE" : "OFFLINE"}
        </span>
        <span className="dash-hdr__time">{updatedAt}</span>
      </div>
    </header>
  );
}
