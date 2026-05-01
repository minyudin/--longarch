import type { FC, ReactNode } from "react";
import type { DataPoint } from "@/types/screen";

interface Props {
  environment: Record<string, number> | null | undefined;
  loading?: boolean;
  /** 历史趋势数据 key=sensorType */
  history?: Record<string, DataPoint[]> | null;
}

interface EnvMetric {
  key: string;
  label: string;
  unit: string;
  icon: string;
  color: string;
  glow: string;
  min: number;
  max: number;
}

const SVG_ICONS: Record<string, (color: string) => ReactNode> = {
  temp: (c) => (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round">
      <path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z" />
    </svg>
  ),
  drop: (c) => (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round">
      <path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z" />
    </svg>
  ),
  sun: (c) => (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round">
      <circle cx="12" cy="12" r="5" />
      <line x1="12" y1="1" x2="12" y2="3" /><line x1="12" y1="21" x2="12" y2="23" />
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" /><line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
      <line x1="1" y1="12" x2="3" y2="12" /><line x1="21" y1="12" x2="23" y2="12" />
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" /><line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
    </svg>
  ),
  wind: (c) => (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round">
      <path d="M9.59 4.59A2 2 0 1 1 11 8H2m10.59 11.41A2 2 0 1 0 14 16H2m15.73-8.27A2.5 2.5 0 1 1 19.5 12H2" />
    </svg>
  ),
};

const METRICS: EnvMetric[] = [
  { key: "temperature", label: "TEMP", unit: "°C", icon: "temp",  color: "#ff6b6b", glow: "rgba(255,107,107,0.4)", min: 0, max: 50 },
  { key: "humidity",    label: "HUMID", unit: "%",  icon: "drop",  color: "#00d4ff", glow: "rgba(0,212,255,0.4)",   min: 0, max: 100 },
  { key: "light",       label: "LUX",  unit: "lx", icon: "sun",   color: "#ffd43b", glow: "rgba(255,212,59,0.4)",  min: 0, max: 60000 },
  { key: "CO2",         label: "CO₂",  unit: "ppm",icon: "wind",  color: "#00ff88", glow: "rgba(0,255,136,0.4)",   min: 0, max: 2000 },
];

function formatValue(v: number | undefined, unit: string): string {
  if (v === undefined || v === null) return "--";
  if (unit === "lx" && v >= 10000) return `${(v / 1000).toFixed(1)}k`;
  return v % 1 === 0 ? String(v) : v.toFixed(1);
}

function percent(v: number | undefined, min: number, max: number): number {
  if (v === undefined || v === null) return 0;
  return Math.min(100, Math.max(0, ((v - min) / (max - min)) * 100));
}

/** SVG Sparkline — 纯展示趋势波形（自适应缩放，上下留 10% 余量） */
function Sparkline({ points, color }: {
  points: DataPoint[];
  color: string;
}) {
  if (!points || points.length < 2) return null;

  const W = 200;
  const H = 36;
  const PAD = 2;
  const n = points.length;

  // 自适应 min/max：用数据自身范围，上下各留 10% 余量
  const values = points.map((p) => Number(p.value));
  const dataMin = Math.min(...values);
  const dataMax = Math.max(...values);
  const margin = (dataMax - dataMin) * 0.1 || 1;
  const scaleMin = dataMin - margin;
  const scaleMax = dataMax + margin;
  const range = scaleMax - scaleMin || 1;

  const coords = points.map((p, i) => {
    const x = PAD + ((W - PAD * 2) / (n - 1)) * i;
    const normalized = Math.min(1, Math.max(0, (Number(p.value) - scaleMin) / range));
    const y = H - PAD - normalized * (H - PAD * 2);
    return { x, y };
  });

  const linePath = coords.map((c, i) => `${i === 0 ? "M" : "L"}${c.x},${c.y}`).join(" ");
  const areaPath = `${linePath} L${coords[n - 1].x},${H} L${coords[0].x},${H} Z`;

  const last = coords[n - 1];
  const lastTime = points[n - 1].sampleAt;
  const timeLabel = lastTime ? lastTime.slice(11, 16) : "";

  return (
    <div className="env-card__spark">
      <svg viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" className="env-card__spark-svg">
        <defs>
          <linearGradient id={`sg-${color.replace("#", "")}`} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={color} stopOpacity="0.25" />
            <stop offset="100%" stopColor={color} stopOpacity="0" />
          </linearGradient>
        </defs>
        <path d={areaPath} fill={`url(#sg-${color.replace("#", "")})`} />
        <path d={linePath} fill="none" stroke={color} strokeWidth="1.5" strokeLinejoin="round" strokeLinecap="round" />
        <circle cx={last.x} cy={last.y} r="2.5" fill={color} />
        <circle cx={last.x} cy={last.y} r="5" fill="none" stroke={color} strokeWidth="0.8" opacity="0.4" />
      </svg>
      <div className="env-card__spark-meta">
        <span className="env-card__spark-count">{n} samples</span>
        {timeLabel && <span className="env-card__spark-time">{timeLabel}</span>}
      </div>
    </div>
  );
}

const EnvCards: FC<Props> = ({ environment, loading, history }) => {
  return (
    <div className="env-cards">
      {METRICS.map((m) => {
        const val = environment?.[m.key];
        const pct = percent(val, m.min, m.max);
        const points = history?.[m.key];

        return (
          <div className={`env-card ${loading ? "env-card--loading" : ""}`} key={m.key}>
            {/* 装饰层 */}
            <div className="env-card__topline" />
            <div className="env-card__glow-sweep" />

            {/* 图标 + 标签 */}
            <div className="env-card__header">
              <div className="env-card__icon-wrap">
                <span className="env-card__icon">{SVG_ICONS[m.icon]?.(m.color)}</span>
              </div>
              <span className="env-card__label">{m.label}</span>
            </div>

            {/* 趋势波形图 */}
            {points && points.length >= 2 && (
              <Sparkline points={points} color={m.color} />
            )}

            {/* 数值 */}
            <div className="env-card__value-row">
              <span className="env-card__value" data-color={m.color}>
                {loading ? "--" : formatValue(val, m.unit)}
              </span>
              <span className="env-card__unit">{m.unit}</span>
            </div>

            {/* 进度条 */}
            <div className="env-card__bar">
              <div
                className="env-card__bar-fill"
                data-color={m.color}
                data-glow={m.glow}
                style={{
                  width: `${loading ? 0 : pct}%`,
                  background: m.color,
                  boxShadow: `0 0 8px ${m.glow}`,
                }}
              />
              <div className="env-card__bar-shine" />
            </div>

            {/* 角标 */}
            <span className="env-card__corner env-card__corner--tl" />
            <span className="env-card__corner env-card__corner--br" />
          </div>
        );
      })}
    </div>
  );
};

export default EnvCards;
