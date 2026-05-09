# Longarch 前后端 Docker 部署说明

本文说明如何用 Docker **构建镜像并运行** PC 管理端前端（`longarch-admin`）与后端（`longarch-server`）。数据库、Redis、MQTT（Mosquitto）等建议单独容器或已有服务，通过环境变量接入。

---

## 一、前置条件

- 已安装 **Docker**（可选：**Docker Compose**）。
- 后端：**JDK 17** 对应运行时镜像（下文示例使用 `eclipse-temurin:17-jre`）。
- 准备可用的 **MySQL 8**、**Redis**、**Mosquitto**，地址与账号与 `deploy/.env.example` 中变量一致（或自行映射到 Spring 配置）。

---

## 二、环境变量（与仓库 `deploy/.env.example` 对齐）

复制模板并按实际环境填写：

```bash
cp deploy/.env.example .env
# 编辑 DB_*、REDIS_*、MQTT_* 等
```

在后端容器中需能通过 Spring Boot 读取上述配置（常用做法：`SPRING_APPLICATION_JSON` 或挂载 `application-prod.yml`，或与现有 `deploy/deploy.sh` 约定一致）。

---

## 三、后端镜像（longarch-server）

**构建上下文**：仓库根目录下的 `longarch-server/`。

示例 `Dockerfile`（可保存为 `longarch-server/Dockerfile`，按需微调）：

```dockerfile
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven && mvn -q -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

构建与运行示例：

```bash
cd longarch-server
docker build -t longarch-server:latest .
docker run --rm -p 8080:8080 --env-file ../.env longarch-server:latest
```

（若 `.env` 键名与 Spring 不一致，请改为 `-e SPRING_DATASOURCE_URL=...` 等形式。）

---

## 四、前端镜像（longarch-admin）

PC 端为 **Vite + Vue**，通常流程：**Node 构建静态资源 → Nginx 托管**。

**构建上下文**：`longarch-admin/`（需先有 `package.json`，构建命令以项目 `scripts` 为准，一般为 `pnpm install && pnpm build`）。

示例 `Dockerfile`（可保存为 `longarch-admin/Dockerfile`）：

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml* package-lock.json* ./
RUN corepack enable && (pnpm install --frozen-lockfile || npm ci)
COPY . .
RUN pnpm build || npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# 可选：自定义 nginx 配置以转发 API 到后端
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

构建与运行示例：

```bash
cd longarch-admin
docker build -t longarch-admin:latest .
docker run --rm -p 80:80 longarch-admin:latest
```

生产环境建议在 Nginx 层将 `/api`（或实际前缀）反向代理到后端 `http://longarch-server:8080`。

---

## 五、Compose 编排示意（可选）

将 **后端、前端** 与 **MySQL / Redis / Mosquitto** 写在同一 `docker-compose.yml` 中，便于一键拉起。以下为结构示意，服务名与镜像名请按实际修改：

```yaml
services:
  backend:
    build: ./longarch-server
    ports: ["8080:8080"]
    env_file: .env
    depends_on: [mysql, redis]

  frontend:
    build: ./longarch-admin
    ports: ["80:80"]
    depends_on: [backend]

  mysql:
    image: mysql:8.0
    # environment、volumes 略

  redis:
    image: redis:7-alpine

  mosquitto:
    image: eclipse-mosquitto:2
```

---

## 六、说明与仓库已有脚本的关系

- 仓库 `deploy/` 下已有 **systemd**、**nginx 配置模板**、**`.env.example`**，适合裸机部署；Docker 部署时仍建议 **同一套环境变量含义**，避免配置分叉。
- **小程序 `miniapp`** 不属于本文「PC 前后端」镜像范围；构建与发布仍按微信开发者工具 / CI 流程。

---

## 七、验收清单（简要）

- [ ] 后端容器健康，可访问接口文档或登录接口（若已开启）。
- [ ] 前端静态页可打开，且接口域名或反向代理指向后端。
- [ ] MySQL / Redis / MQTT 连通，`application-prod` 或等价变量正确。

如需把上述 `Dockerfile` 真正落到仓库根目录，可从本文复制后单独提交工程文件。
