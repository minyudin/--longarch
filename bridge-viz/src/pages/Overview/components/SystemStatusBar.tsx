import { useState, useEffect, type FC } from "react";

const FAKE_METRICS = [
  { label: "CPU", suffix: "%" },
  { label: "MEM", suffix: "%" },
  { label: "NET", suffix: "ms" },
  { label: "I/O", suffix: "KB/s" },
];

function pad(n: number) {
  return String(n).padStart(2, "0");
}

const SystemStatusBar: FC = () => {
  const [time, setTime] = useState(() => new Date());
  const [metrics, setMetrics] = useState(() =>
    FAKE_METRICS.map(() => Math.random() * 40 + 10)
  );

  useEffect(() => {
    const t = setInterval(() => {
      setTime(new Date());
      setMetrics((prev) =>
        prev.map((v) => Math.max(5, Math.min(95, v + (Math.random() - 0.5) * 8)))
      );
    }, 1000);
    return () => clearInterval(t);
  }, []);

  const hh = pad(time.getHours());
  const mm = pad(time.getMinutes());
  const ss = pad(time.getSeconds());

  return (
    <div className="sys-bar">
      {/* 顶部装饰线 */}
      <div className="sys-bar__topline" />

      {/* 左侧：脉冲灯 + 状态 */}
      <div className="sys-bar__section">
        <span className="sys-bar__pulse" />
        <span className="sys-bar__label">SYS ONLINE</span>
        <span className="sys-bar__divider">│</span>
        <span className="sys-bar__label sys-bar__label--dim">UPTIME 24:00:00</span>
      </div>

      {/* 中间：假指标 */}
      <div className="sys-bar__section sys-bar__section--metrics">
        {FAKE_METRICS.map((m, i) => (
          <div className="sys-bar__metric" key={m.label}>
            <span className="sys-bar__metric-label">{m.label}</span>
            <span className="sys-bar__metric-value">
              {metrics[i].toFixed(1)}
            </span>
            <span className="sys-bar__metric-suffix">{m.suffix}</span>
            {/* mini bar */}
            <div className="sys-bar__metric-bar">
              <div
                className="sys-bar__metric-bar-fill"
                style={{ width: `${Math.min(100, metrics[i])}%` }}
              />
            </div>
          </div>
        ))}
      </div>

      {/* 右侧：时钟 */}
      <div className="sys-bar__section">
        <span className="sys-bar__divider">│</span>
        <span className="sys-bar__clock">
          {hh}
          <span className="sys-bar__clock-blink">:</span>
          {mm}
          <span className="sys-bar__clock-blink">:</span>
          {ss}
        </span>
      </div>
    </div>
  );
};

export default SystemStatusBar;
