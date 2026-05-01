import type { FC } from "react";
import type { PlotPointInfo } from "@/types/screen";

interface Props {
  plots: PlotPointInfo[] | undefined;
  loading?: boolean;
}

interface SoilMetric {
  key: string;
  label: string;
  unit: string;
  color: string;
  /** min/max for normalizing the spider chart axis */
  range: [number, number];
}

const SOIL_METRICS: SoilMetric[] = [
  { key: "N",            label: "N",    unit: "mg/kg", color: "#00ff88", range: [0, 50]  },
  { key: "P",            label: "P",    unit: "mg/kg", color: "#00d4ff", range: [0, 30]  },
  { key: "K",            label: "K",    unit: "mg/kg", color: "#ffd43b", range: [0, 80]  },
  { key: "pH",           label: "pH",   unit: "",      color: "#ff6b6b", range: [3, 10]  },
  { key: "soilTemp",     label: "TEMP", unit: "°C",    color: "#ff9f43", range: [0, 45]  },
  { key: "soilMoisture", label: "WET",  unit: "%",     color: "#54a0ff", range: [0, 100] },
];

/* ── SVG 蛛网雷达图 ── */
const CX = 60, CY = 60, R = 46;
const RINGS = [0.33, 0.66, 1];
const ANGLES = SOIL_METRICS.map((_, i) => (Math.PI * 2 * i) / SOIL_METRICS.length - Math.PI / 2);

function polarX(angle: number, r: number) { return CX + r * Math.cos(angle); }
function polarY(angle: number, r: number) { return CY + r * Math.sin(angle); }

function ringPoints(scale: number): string {
  return ANGLES.map((a) => `${polarX(a, R * scale).toFixed(1)},${polarY(a, R * scale).toFixed(1)}`).join(" ");
}

function normalize(value: number | undefined, range: [number, number]): number {
  if (value === undefined || value === null) return 0;
  return Math.min(1, Math.max(0, (value - range[0]) / (range[1] - range[0])));
}

const SoilSpider: FC<{ sensors: Record<string, number> }> = ({ sensors }) => {
  const dataPoints = SOIL_METRICS.map((m, i) => {
    const norm = normalize(sensors[m.key], m.range);
    const clamp = Math.max(norm, 0.06); // min visible radius
    return `${polarX(ANGLES[i], R * clamp).toFixed(1)},${polarY(ANGLES[i], R * clamp).toFixed(1)}`;
  }).join(" ");

  const hasData = SOIL_METRICS.some((m) => sensors[m.key] !== undefined);

  return (
    <svg className="plot-card__spider" viewBox="0 0 120 120">
      {/* 网格环 */}
      {RINGS.map((s) => (
        <polygon key={s} points={ringPoints(s)} className="plot-card__spider-ring" />
      ))}
      {/* 轴线 */}
      {ANGLES.map((a, i) => (
        <line key={i} x1={CX} y1={CY} x2={polarX(a, R)} y2={polarY(a, R)} className="plot-card__spider-axis" />
      ))}
      {/* 数据区域 */}
      {hasData && (
        <polygon points={dataPoints} className="plot-card__spider-data" />
      )}
      {/* 数据点 */}
      {hasData && SOIL_METRICS.map((m, i) => {
        const norm = Math.max(normalize(sensors[m.key], m.range), 0.06);
        return (
          <circle key={m.key} cx={polarX(ANGLES[i], R * norm)} cy={polarY(ANGLES[i], R * norm)}
            r="2" className="plot-card__spider-dot" />
        );
      })}
      {/* 轴标签 */}
      {SOIL_METRICS.map((m, i) => {
        const labelR = R + 11;
        const x = polarX(ANGLES[i], labelR);
        const y = polarY(ANGLES[i], labelR);
        return (
          <text key={m.key} x={x} y={y} className="plot-card__spider-label"
            textAnchor="middle" dominantBaseline="central">{m.label}</text>
        );
      })}
    </svg>
  );
};

function fmt(v: number | undefined): string {
  if (v === undefined || v === null) return "--";
  return v % 1 === 0 ? String(v) : v.toFixed(1);
}

const PlotGrid: FC<Props> = ({ plots, loading }) => {
  if (loading) {
    return (
      <div className="plot-grid">
        {[1, 2, 3, 4].map((i) => (
          <div className="plot-card plot-card--skeleton" key={i}>
            <div className="plot-card__shimmer" />
          </div>
        ))}
      </div>
    );
  }

  if (!plots || plots.length === 0) {
    return (
      <div className="plot-grid plot-grid--empty">
        <span className="plot-grid__empty-text">NO SOIL POINTS</span>
      </div>
    );
  }

  return (
    <div className="plot-grid">
      {plots.map((p) => {
        const hasSensors = Object.keys(p.sensors).length > 0;
        return (
          <div
            className={`plot-card ${hasSensors ? "" : "plot-card--no-data"}`}
            key={p.plotId}
          >
            {/* 装饰层 */}
            <div className="plot-card__topline" />
            <div className="plot-card__glow" />
            <div className="plot-card__head">
              <span className="plot-card__index">
                #{String(p.plotId).slice(-2)}
              </span>
              <span className="plot-card__name">{p.plotName}</span>
              <span className={`plot-card__status ${hasSensors ? "plot-card__status--on" : "plot-card__status--off"}`}>
                {hasSensors ? "ACTIVE" : "IDLE"}
              </span>
            </div>

            {/* 蛛网雷达图 */}
            <SoilSpider sensors={p.sensors} />

            {/* 传感器数值行 */}
            <div className="plot-card__metrics plot-card__metrics--compact">
              {SOIL_METRICS.map((m) => (
                <div className="plot-card__metric" key={m.key}>
                  <span className="plot-card__metric-label">{m.label}</span>
                  <span
                    className="plot-card__metric-value"
                    style={{ color: hasSensors && p.sensors[m.key] !== undefined ? m.color : undefined }}
                  >
                    {fmt(p.sensors[m.key])}
                  </span>
                  {m.unit && <span className="plot-card__metric-unit">{m.unit}</span>}
                </div>
              ))}
            </div>

            {/* 最后采样时间 */}
            <div className="plot-card__footer">
              <span className="plot-card__ts">
                {p.lastSampleAt ? p.lastSampleAt.replace(/^\d{4}-\d{2}-\d{2}\s/, "") : "--:--:--"}
              </span>
            </div>

            {/* 角标 */}
            <span className="plot-card__corner plot-card__corner--tl" />
            <span className="plot-card__corner plot-card__corner--br" />
          </div>
        );
      })}
    </div>
  );
};

export default PlotGrid;
