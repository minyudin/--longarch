import { type FC } from "react";

const RadarSweep: FC = () => {
  return (
    <div className="radar">
      {/* 外框装饰 */}
      <div className="radar__frame">
        <span className="radar__corner radar__corner--tl" />
        <span className="radar__corner radar__corner--tr" />
        <span className="radar__corner radar__corner--bl" />
        <span className="radar__corner radar__corner--br" />

        {/* 标题栏 */}
        <div className="radar__title-bar">
          <span className="radar__dot" />
          <span className="radar__title">RADAR SCAN</span>
        </div>

        {/* 雷达主体 */}
        <div className="radar__body">
          <svg className="radar__svg" viewBox="0 0 200 200">
            {/* 同心圆 */}
            <circle className="radar__ring" cx="100" cy="100" r="90" />
            <circle className="radar__ring" cx="100" cy="100" r="60" />
            <circle className="radar__ring" cx="100" cy="100" r="30" />

            {/* 十字线 */}
            <line className="radar__cross" x1="10" y1="100" x2="190" y2="100" />
            <line className="radar__cross" x1="100" y1="10" x2="100" y2="190" />

            {/* 假目标点 */}
            <circle className="radar__blip radar__blip--1" cx="130" cy="65" r="3" />
            <circle className="radar__blip radar__blip--2" cx="70"  cy="120" r="2.5" />
            <circle className="radar__blip radar__blip--3" cx="145" cy="130" r="2" />
            <circle className="radar__blip radar__blip--4" cx="55"  cy="60"  r="2" />
          </svg>

          {/* 扫描扇面 — 用 conic-gradient 实现旋转 */}
          <div className="radar__sweep" />

          {/* 中心亮点 */}
          <div className="radar__center" />
        </div>

        {/* 底部假数据 */}
        <div className="radar__footer">
          <span className="radar__meta">AZ 127.4°</span>
          <span className="radar__meta">EL 34.2°</span>
          <span className="radar__meta">RNG 2.8km</span>
        </div>
      </div>
    </div>
  );
};

export default RadarSweep;
