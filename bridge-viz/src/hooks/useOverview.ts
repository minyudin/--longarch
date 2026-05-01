import { useEffect, useRef, useState, useCallback } from "react";
import { fetchOverview } from "@/api/screen";
import type { ScreenOverviewVO } from "@/types/screen";

const POLL_INTERVAL = 10_000; // 10 秒轮询，与业务文档一致

/**
 * 大屏总览数据 Hook — 自动轮询
 *
 * @returns { data, error, loading, refresh }
 */
export function useOverview(greenhouseId?: number | null) {
  const [data, setData] = useState<ScreenOverviewVO | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const load = useCallback(async () => {
    try {
      const result = await fetchOverview(greenhouseId);
      setData(result);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : "未知错误");
    } finally {
      setLoading(false);
    }
  }, [greenhouseId]);

  useEffect(() => {
    setLoading(true);
    load();
    timerRef.current = setInterval(load, POLL_INTERVAL);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [load]);

  return { data, error, loading, refresh: load };
}
