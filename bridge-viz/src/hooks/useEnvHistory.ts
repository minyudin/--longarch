import { useEffect, useRef, useState, useCallback } from "react";
import { fetchEnvHistory } from "@/api/screen";
import type { EnvHistoryVO } from "@/types/screen";

const POLL_INTERVAL = 30_000; // 30 秒轮询（历史数据不需要太频繁）

/**
 * 环境传感器历史数据 Hook — 自动轮询
 */
export function useEnvHistory(limit = 50, greenhouseId?: number | null) {
  const [data, setData] = useState<EnvHistoryVO | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const load = useCallback(async () => {
    try {
      const result = await fetchEnvHistory(limit, greenhouseId);
      setData(result);
    } catch {
      // 静默失败，sparkline 不是核心功能
    }
  }, [limit, greenhouseId]);

  useEffect(() => {
    load();
    timerRef.current = setInterval(load, POLL_INTERVAL);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [load]);

  return data;
}
