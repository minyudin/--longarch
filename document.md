# 数据库实践系统解析报告

**项目名称：** longarch (智慧农业认养平台)
**数据库类型：** MySQL 8.0.42
**分析日期：** 2026年4月21日

---

## 目录

1. [系统概述](#1-系统概述)
2. [核心业务模块详解](#2-核心业务模块详解)
3. [系统 E-R 图](#3-系统-e-r-图)
4. [关键表结构逻辑分析](#4-关键表结构逻辑分析)
5. [数据关联关系图](#5-数据关联关系图)
6. [数据质量与潜在问题建议](#6-数据质量与潜在问题建议)
7. [总结](#7-总结)

---

## 1. 系统概述

该系统是一个典型的农业物联网 + 认养经济平台。其核心业务逻辑为：

1. **数据采集：** 通过边缘节点和各类传感器（土壤、环境、NPK等）采集农田/大棚环境数据。
2. **认养流转：** 用户通过认养码绑定地块，形成订单，获取远程查看和操作权限。
3. **智能控制：** 用户或系统（AI）发起操作任务，系统通过设备锁和队列机制向执行设备（灌溉、施肥、遮阳帘等）下发指令。
4. **AI 决策：** 系统结合传感器快照和作物生长阶段进行 AI 分析，给出农事建议。

---

## 2. 核心业务模块详解

### 2.1 用户与权限体系

**主要涉及数据表：** `user`, `adoption_code`, `adoption_order`

- **用户分层**：
  - `admin`：系统管理员
  - `operator`：基地运营/农技人员
  - `adopter`：普通认养用户

- **认养机制**：
  - 采用“一田一码”或“一田多码”模式
  - **主码 (master)**：绑定用户后可拥有完整操作权限（灌溉、施肥等）
  - **访客码 (guest)**：通常只有查看权限，无操作权限

- **权限控制精细**：
  - `adoption_code` 表中有 `operation_whitelist`（操作白名单）和 `max_daily_operations`（每日最大操作次数）字段，用于限制远程农事操作

### 2.2 农场资源管理

**主要涉及数据表：** `plot`, `edge_node`, `crop_batch`

- **地块结构**：支持层级划分（如 `A区1号田` → `1#点位`），方便精细化管理
- **作物批次**：每个地块关联当前种植的作物批次（`crop_batch`），记录播种时间、预计收获时间以及生长阶段（`growth_stage`，如抽穗期、块茎膨大期）
- **边缘计算**：`edge_node` 作为现场网关，管理传感器和执行设备的网络状态及心跳

### 2.3 监控与感知层

**主要涉及数据表：** `sensor_device`, `sensor_data`, `camera_device`, `screen_device`

- **传感器种类**：
  - **土壤类**：温度、湿度、pH、NPK（氮磷钾）
  - **环境类**：空气温湿度、光照、CO2 浓度

- **数据存储**：`sensor_data` 采用时序数据存储模式，按时间插入采样值

- **多媒体监控**：
  - **摄像头**：支持 RTMP/WebRTC 推流，并支持 PTZ（云台控制）
  - **大屏展示**：`screen_device` 用于农场内数据可视化展示

### 2.4 农事作业与 AI 决策

**主要涉及数据表：** `ai_analysis_record`, `operation_task`, `device_execution_log`

- **AI 分析流程**：
  - 触发方式：定时 (`periodic`)、手动 (`manual`)、告警 (`alert`)
  - 输入：当前传感器快照 + 作物批次信息
  - 输出：`analysis_result`（分析结论）、`risk_level`（风险等级）、`suggested_actions`（建议操作）

- **任务执行流**：
  - **任务创建**：用户/AI 创建 `operation_task`
  - **幂等控制**：通过 `idempotency_key` 防止重复提交
  - **队列与锁**：`operation_task_queue` 进行排队，`device_lock` 确保同一设备同一时间只执行一个任务
  - **执行反馈**：`device_execution_log` 记录下发指令与回调结果

### 2.5 农事记录

**主要涉及数据表：** `farming_record`

- 记录人工/机器执行的农事活动（播种、施肥、打药等），形成溯源数据

---

## 3. 系统 E-R 图

### 3.1 完整 E-R 图（Mermaid 代码）

您可以将以下 Mermaid 代码复制到支持 Mermaid 的编辑器（如 Typora、Notion、GitHub、Obsidian 或在线 Mermaid Live Editor）中，即可自动渲染成 E-R 图。
```mermaid
erDiagram
    %% 用户与认养模块
    USER {
        bigint id PK
        varchar user_no UK
        varchar open_id UK
        varchar nickname
        varchar role_type
    }
    
    ADOPTION_ORDER {
        bigint id PK
        varchar order_no UK
        bigint user_id FK
        bigint plot_id FK
        bigint crop_batch_id FK
        varchar order_status
        datetime start_at
        datetime end_at
    }
    
    ADOPTION_CODE {
        bigint id PK
        varchar code UK
        bigint order_id FK
        bigint plot_id FK
        bigint bind_user_id FK
        varchar code_type
        varchar status
    }
    
    %% 地块与作物模块
    PLOT {
        bigint id PK
        varchar plot_no UK
        varchar plot_name
        bigint farm_id
        bigint parent_id FK
        decimal area_size
        varchar plot_status
    }
    
    CROP_BATCH {
        bigint id PK
        varchar batch_no UK
        bigint plot_id FK
        varchar crop_name
        varchar growth_stage
        datetime sowing_at
        datetime expected_harvest_at
    }
    
    FARMING_RECORD {
        bigint id PK
        bigint plot_id FK
        bigint crop_batch_id FK
        varchar record_type
        varchar record_title
        datetime record_time
    }
    
    %% 传感器模块
    SENSOR_DEVICE {
        bigint id PK
        varchar device_no UK
        bigint plot_id FK
        varchar sensor_type
        varchar category
        varchar status
    }
    
    SENSOR_DATA {
        bigint id PK
        bigint sensor_id FK
        bigint plot_id FK
        varchar sensor_type
        decimal value
        datetime sample_at
    }
    
    %% 执行设备与任务模块
    ACTUATOR_DEVICE {
        bigint id PK
        varchar device_no UK
        bigint plot_id FK
        varchar device_type
        varchar device_status
    }
    
    DEVICE_LOCK {
        bigint id PK
        bigint device_id UK
        bigint current_task_id FK
        varchar lock_status
        datetime lock_expire_at
    }
    
    OPERATION_TASK {
        bigint id PK
        varchar task_no UK
        bigint request_user_id FK
        bigint plot_id FK
        bigint device_id FK
        varchar action_type
        varchar task_status
    }
    
    DEVICE_EXECUTION_LOG {
        bigint id PK
        bigint task_id FK
        bigint device_id FK
        varchar execution_status
        datetime dispatched_at
    }
    
    %% AI 分析模块
    AI_ANALYSIS_RECORD {
        bigint id PK
        bigint plot_id FK
        varchar analysis_type
        json sensor_snapshot
        text analysis_result
        varchar risk_level
        datetime created_at
    }
    
    %% 视频监控模块
    CAMERA_DEVICE {
        bigint id PK
        varchar device_no UK
        bigint plot_id FK
        varchar stream_protocol
        varchar network_status
    }
    
    SCREEN_DEVICE {
        bigint id PK
        varchar device_no UK
        bigint plot_id FK
        varchar screen_token UK
        varchar status
    }
    
    EDGE_NODE {
        bigint id PK
        varchar node_no UK
        bigint farm_id
        varchar network_status
        datetime last_heartbeat_at
    }
    
    %% 关系定义
    USER ||--o{ ADOPTION_ORDER : "创建/拥有"
    USER ||--o{ ADOPTION_CODE : "绑定"
    ADOPTION_ORDER ||--o{ ADOPTION_CODE : "生成"
    
    PLOT ||--o{ ADOPTION_ORDER : "被认养"
    PLOT ||--o{ ADOPTION_CODE : "关联"
    PLOT ||--o{ CROP_BATCH : "种植历史"
    PLOT ||--o{ SENSOR_DEVICE : "部署"
    PLOT ||--o{ ACTUATOR_DEVICE : "部署"
    PLOT ||--o{ CAMERA_DEVICE : "部署"
    PLOT ||--o{ SCREEN_DEVICE : "部署"
    PLOT ||--o{ FARMING_RECORD : "产生"
    PLOT ||--o{ OPERATION_TASK : "目标地块"
    PLOT ||--o{ AI_ANALYSIS_RECORD : "分析对象"
    
    CROP_BATCH ||--o{ FARMING_RECORD : "记录"
    
    SENSOR_DEVICE ||--o{ SENSOR_DATA : "采集"
    
    ACTUATOR_DEVICE ||--|| DEVICE_LOCK : "设备锁"
    ACTUATOR_DEVICE ||--o{ OPERATION_TASK : "执行任务"
    
    OPERATION_TASK ||--o{ DEVICE_EXECUTION_LOG : "产生日志"
    
    EDGE_NODE ||--o{ ACTUATOR_DEVICE : "管理"
    EDGE_NODE ||--o{ SENSOR_DEVICE : "管理"
