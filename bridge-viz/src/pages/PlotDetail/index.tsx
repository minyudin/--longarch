import MatrixRain from "@/components/MatrixRain";

export default function PlotDetail() {
  return (
    <div className="page-wrapper">
      {/* 背景特效层 */}
      <MatrixRain />
      <div className="grid-overlay" />
      <div className="scan-line" />
      <div className="hack-lines">
        <div className="hack-line" />
        <div className="hack-line" />
        <div className="hack-line" />
      </div>

      {/* 占位：后续填充真实子组件 */}
      <div className="page-content">
        <div className="section-header">
          <span className="section-number">02</span>
          <h2 className="section-title">
            <span className="gradient-text">PLOT DETAIL</span>
            <span className="title-underline" />
          </h2>
        </div>
      </div>
    </div>
  );
}