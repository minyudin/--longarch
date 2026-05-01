import http from "./request";
import type { ScreenOverviewVO, EnvHistoryVO, GreenhouseListVO } from "@/types/screen";

/**
 * 同农场大棚列表（切换器用）
 * GET /screen/greenhouses
 */
export function fetchGreenhouses(): Promise<GreenhouseListVO> {
  return http.get("/screen/greenhouses");
}

/**
 * 大屏数据总览
 * GET /screen/overview?greenhouseId=xxx
 */
export function fetchOverview(greenhouseId?: number | null): Promise<ScreenOverviewVO> {
  return http.get("/screen/overview", { params: greenhouseId ? { greenhouseId } : {} });
}

/**
 * 环境传感器历史数据（sparkline 用）
 * GET /screen/env-history?greenhouseId=xxx&limit=50
 */
export function fetchEnvHistory(limit = 50, greenhouseId?: number | null): Promise<EnvHistoryVO> {
  const params: Record<string, unknown> = { limit };
  if (greenhouseId) params.greenhouseId = greenhouseId;
  return http.get("/screen/env-history", { params });
}
