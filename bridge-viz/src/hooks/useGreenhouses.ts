import { useEffect, useState } from "react";
import { fetchGreenhouses } from "@/api/screen";
import type { GreenhouseListVO } from "@/types/screen";

/**
 * 大棚列表 Hook — 仅加载一次（切换器用）
 */
export function useGreenhouses() {
  const [data, setData] = useState<GreenhouseListVO | null>(null);

  useEffect(() => {
    fetchGreenhouses()
      .then(setData)
      .catch(() => {});
  }, []);

  return data;
}
