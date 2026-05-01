/**
 * 后端统一响应信封 — 对齐 com.longarch.common.result.R<T>
 */
export interface R<T> {
  code: number;
  message: string;
  data: T;
  requestId: string;
  serverTime: string;
}

/**
 * 大屏数据总览 — 对齐 ScreenOverviewVO（点位制架构）
 * GET /api/v1/screen/overview
 */
export interface ScreenOverviewVO {
  greenhouseName: string;
  farmName: string;
  camera: CameraInfo | null;
  environment: Record<string, number>;
  plots: PlotPointInfo[];
  updatedAt: string;
}

/**
 * 摄像头信息 — 对齐 ScreenOverviewVO.CameraInfo
 */
export interface CameraInfo {
  cameraId: number;
  cameraName: string;
  flvUrl: string;
  hlsUrl: string;
  status: string;
}

/**
 * 土壤点位信息 — 对齐 ScreenOverviewVO.PlotPointInfo
 * sensors: { N:3.1, P:1.8, K:5.2, pH:6.8, soilTemp:22.5, soilMoisture:65.3 }
 */
export interface PlotPointInfo {
  plotId: number;
  plotName: string;
  sensors: Record<string, number>;
  lastSampleAt: string | null;
}

/**
 * 环境传感器历史数据 — 对齐 EnvHistoryVO
 * GET /api/v1/screen/env-history?limit=50
 */
export interface EnvHistoryVO {
  series: Record<string, DataPoint[]>;
}

export interface DataPoint {
  value: number;
  sampleAt: string;
}

/**
 * 大棚列表 — 对齐 GreenhouseListVO
 * GET /api/v1/screen/greenhouses
 */
export interface GreenhouseListVO {
  farmName: string;
  greenhouses: GreenhouseItem[];
}

export interface GreenhouseItem {
  id: number;
  name: string;
  plotCount: number;
}
