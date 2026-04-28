#!/usr/bin/env bash
set -euo pipefail

# ============================================================
#  韶山稻梦田园智慧大棚 — 一键部署脚本
#  用法: bash deploy.sh [--skip-backend] [--skip-frontend]
# ============================================================

APP_NAME="longarch"
DEPLOY_DIR="/opt/longarch"
BACKEND_DIR="${DEPLOY_DIR}/backend"
DASHBOARD_DIR="${DEPLOY_DIR}/dashboard"
LOG_DIR="${DEPLOY_DIR}/logs"
NGINX_CONF="/etc/nginx/conf.d/longarch.conf"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_SRC="${REPO_ROOT}/longarch-server"
FRONTEND_SRC="${REPO_ROOT}/demo2-standalone"

SKIP_BACKEND=false
SKIP_FRONTEND=false

for arg in "$@"; do
  case $arg in
    --skip-backend)  SKIP_BACKEND=true ;;
    --skip-frontend) SKIP_FRONTEND=true ;;
  esac
done

echo "=========================================="
echo "  Deploy: ${APP_NAME}"
echo "  Time:   $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# ---------- 目录准备 ----------
mkdir -p "${BACKEND_DIR}" "${DASHBOARD_DIR}" "${LOG_DIR}"

# ---------- 后端构建 & 部署 ----------
if [ "$SKIP_BACKEND" = false ]; then
  echo ""
  echo "[1/4] Building backend …"
  cd "${BACKEND_SRC}"
  mvn clean package -DskipTests -Pprod -q

  JAR_FILE=$(ls -t target/*.jar 2>/dev/null | head -1)
  if [ -z "${JAR_FILE}" ]; then
    echo "ERROR: No jar found in target/"; exit 1
  fi
  cp "${JAR_FILE}" "${BACKEND_DIR}/${APP_NAME}.jar"
  echo "  → jar copied to ${BACKEND_DIR}/${APP_NAME}.jar"

  echo ""
  echo "[2/4] Restarting backend service …"
  # systemd unit 需预先创建（见下方说明）
  sudo systemctl restart "${APP_NAME}" || {
    echo "  ⚠  systemd unit not found, starting manually …"
    nohup java -jar "${BACKEND_DIR}/${APP_NAME}.jar" \
      --spring.profiles.active=prod \
      > "${LOG_DIR}/backend-stdout.log" 2>&1 &
    echo "  → PID: $!"
  }
else
  echo ""
  echo "[1/4] Skipping backend build"
  echo "[2/4] Skipping backend restart"
fi

# ---------- 前端构建 & 部署 ----------
if [ "$SKIP_FRONTEND" = false ]; then
  echo ""
  echo "[3/4] Building frontend …"
  cd "${FRONTEND_SRC}"
  pnpm install --frozen-lockfile
  pnpm run build

  echo "  → Syncing dist to ${DASHBOARD_DIR}/dist …"
  rsync -a --delete dist/ "${DASHBOARD_DIR}/dist/"
else
  echo ""
  echo "[3/4] Skipping frontend build"
fi

# ---------- Nginx ----------
echo ""
echo "[4/4] Configuring Nginx …"
NGINX_TEMPLATE="${REPO_ROOT}/deploy/nginx-longarch.conf"
if [ -f "${NGINX_TEMPLATE}" ]; then
  sudo cp "${NGINX_TEMPLATE}" "${NGINX_CONF}"
  sudo nginx -t && sudo systemctl reload nginx
  echo "  → Nginx reloaded"
else
  echo "  ⚠  Nginx template not found at ${NGINX_TEMPLATE}"
fi

echo ""
echo "=========================================="
echo "  Deploy finished: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
