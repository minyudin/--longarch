import { useState } from "react";
import MatrixRain from "@/components/MatrixRain";
import { useOverview } from "@/hooks/useOverview";
import { useEnvHistory } from "@/hooks/useEnvHistory";
import { useGreenhouses } from "@/hooks/useGreenhouses";
import DashboardHeader from "./components/DashboardHeader";
import GreenhouseSwitcher from "./components/GreenhouseSwitcher";
import CameraPanel from "./components/CameraPanel";
import EnvCards from "./components/EnvCards";
import PlotGrid from "./components/PlotGrid";
import RadarSweep from "./components/RadarSweep";
import SystemStatusBar from "./components/SystemStatusBar";

export default function Overview() {
  const ghList = useGreenhouses();
  const [activeGhId, setActiveGhId] = useState<number | null>(null);

  const currentGhId = activeGhId ?? ghList?.greenhouses?.[0]?.id ?? null;
  const { data, error, loading } = useOverview(currentGhId);
  const envHistory = useEnvHistory(50, currentGhId);

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

      {/* 前景内容 */}
      <div className="page-content">
        <DashboardHeader
          greenhouseName={data?.greenhouseName ?? "---"}
          farmName={data?.farmName ?? "---"}
          updatedAt={data?.updatedAt ?? "--:--:--"}
          cameraStatus={data?.camera?.status ?? null}
          plotCount={data?.plots?.length ?? 0}
          activePlots={data?.plots?.filter((p) => Object.keys(p.sensors).length > 0).length ?? 0}
          envMetrics={data?.environment ? Object.keys(data.environment).length : 0}
        />

        {ghList && ghList.greenhouses.length > 1 && (
          <GreenhouseSwitcher
            greenhouses={ghList.greenhouses}
            activeId={currentGhId}
            onSwitch={setActiveGhId}
          />
        )}

        <div className="overview-body">
          <div className="overview-body__left">
            <div className="overview-body__camera">
              <CameraPanel camera={data?.camera ?? null} loading={loading && !data} />
            </div>
            <div className="overview-body__radar">
              <RadarSweep />
            </div>
          </div>
          <div className="overview-body__right">
            <EnvCards environment={data?.environment} loading={loading && !data} history={envHistory?.series} />
            <PlotGrid plots={data?.plots} loading={loading && !data} />
          </div>
        </div>

        <SystemStatusBar />

        {loading && !data && (
          <div className="loading-hint">数据加载中...</div>
        )}
        {error && (
          <div className="error-hint">连接失败: {error}</div>
        )}
      </div>
    </div>
  );
}