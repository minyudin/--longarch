import axios from "axios";
import type { R } from "@/types/screen";

/**
 * Axios 实例 — 大屏专用
 *
 * - baseURL 来自环境变量 VITE_API_BASE（默认 /api/v1）
 * - X-Screen-Token 来自 URL query 参数 ?token=xxx
 *   如果 URL 上没有 token，则回退到环境变量 VITE_DASHBOARD_TOKEN（仅开发用）
 * - 响应拦截器自动解包 R<T> 信封，只返回 data 字段
 */

function getScreenToken(): string {
  const params = new URLSearchParams(window.location.search);
  return params.get("token") || import.meta.env.VITE_DASHBOARD_TOKEN || "";
}

const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || "/api/v1",
  timeout: 15_000,
  headers: {
    "Content-Type": "application/json",
  },
});

// 请求拦截器：自动注入 X-Screen-Token
http.interceptors.request.use((config) => {
  const token = getScreenToken();
  if (token) {
    config.headers["X-Screen-Token"] = token;
  }
  return config;
});

// 响应拦截器：解包 R<T> 信封
http.interceptors.response.use(
  (response) => {
    const body = response.data as R<unknown>;
    if (body.code !== 0) {
      return Promise.reject(
        new Error(body.message || `请求失败 (code=${body.code})`),
      );
    }
    return body.data as never;
  },
  (error) => {
    const msg =
      error.response?.data?.message ||
      error.message ||
      "网络异常，请检查连接";
    return Promise.reject(new Error(msg));
  },
);

export default http;
