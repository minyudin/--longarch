/*
 Navicat Premium Dump SQL

 Source Server         : DMY
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : longarch

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 21/04/2026 21:12:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for actuator_device
-- ----------------------------
DROP TABLE IF EXISTS `actuator_device`;
CREATE TABLE `actuator_device`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `device_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `plot_id` bigint NOT NULL,
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'irrigator/fertilizer/sprayer',
  `device_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'idle',
  `edge_node_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `network_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'offline',
  `last_heartbeat_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_device_no`(`device_no` ASC) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 80016 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '执行设备表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of actuator_device
-- ----------------------------
INSERT INTO `actuator_device` VALUES (80001, 'ACT-A001-IRR', 'A区1号田浇水设备', 30001, 'irrigator', 'idle', 'EDGE-001', 'offline', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `actuator_device` VALUES (80002, 'ACT-A001-FERT', 'A区1号田施肥设备', 30001, 'fertilizer', 'idle', 'EDGE-001', 'offline', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `actuator_device` VALUES (80003, 'ACT-A002-IRR', 'A区2号田浇水设备', 30002, 'irrigator', 'idle', 'EDGE-001', 'offline', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `actuator_device` VALUES (80004, 'ACT-DM01-FER', '1号棚水肥一体机', 30003, 'fertigation_machine', 'idle', 'EDGE-DM01', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:21');
INSERT INTO `actuator_device` VALUES (80005, 'ACT-DM01-SHA', '1号棚遮阳帘控制器', 30003, 'shade_controller', 'idle', 'EDGE-DM01', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:21');
INSERT INTO `actuator_device` VALUES (80006, 'ACT-DM01-WET', '1号棚湿帘控制器', 30003, 'wet_curtain_controller', 'idle', 'EDGE-DM01', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:21');
INSERT INTO `actuator_device` VALUES (80007, 'ACT-DM01-FAN', '1号棚换气扇控制器', 30003, 'ventilation_fan_controller', 'idle', 'EDGE-DM01', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:22');
INSERT INTO `actuator_device` VALUES (80008, 'ACT-DM02-FER', '2号棚水肥一体机', 30004, 'fertigation_machine', 'idle', 'EDGE-DM02', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:22');
INSERT INTO `actuator_device` VALUES (80009, 'ACT-DM02-SHA', '2号棚遮阳帘控制器', 30004, 'shade_controller', 'idle', 'EDGE-DM02', 'offline', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:22');
INSERT INTO `actuator_device` VALUES (80010, 'ACT-DM02-WET', '2号棚湿帘控制器', 30004, 'wet_curtain_controller', 'idle', 'EDGE-DM02', 'offline', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:22');
INSERT INTO `actuator_device` VALUES (80011, 'ACT-DM02-FAN', '2号棚换气扇控制器', 30004, 'ventilation_fan_controller', 'idle', 'EDGE-DM02', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:23');
INSERT INTO `actuator_device` VALUES (80012, 'ACT-DM03-FER', '3号棚水肥一体机', 30005, 'fertigation_machine', 'idle', 'EDGE-DM03', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:23');
INSERT INTO `actuator_device` VALUES (80013, 'ACT-DM03-SHA', '3号棚遮阳帘控制器', 30005, 'shade_controller', 'idle', 'EDGE-DM03', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:23');
INSERT INTO `actuator_device` VALUES (80014, 'ACT-DM03-WET', '3号棚湿帘控制器', 30005, 'wet_curtain_controller', 'idle', 'EDGE-DM03', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:23');
INSERT INTO `actuator_device` VALUES (80015, 'ACT-DM03-FAN', '3号棚换气扇控制器', 30005, 'ventilation_fan_controller', 'idle', 'EDGE-DM03', 'online', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:37:24');

-- ----------------------------
-- Table structure for adoption_code
-- ----------------------------
DROP TABLE IF EXISTS `adoption_code`;
CREATE TABLE `adoption_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '认养码',
  `code_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'master' COMMENT 'master/guest/share',
  `order_id` bigint NOT NULL,
  `plot_id` bigint NOT NULL,
  `crop_batch_id` bigint NULL DEFAULT NULL,
  `bind_user_id` bigint NULL DEFAULT NULL COMMENT '兑换绑定的用户',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `daily_access_start` time NULL DEFAULT '08:00:00',
  `daily_access_end` time NULL DEFAULT '22:00:00',
  `can_view_live` tinyint NOT NULL DEFAULT 1,
  `can_view_history` tinyint NOT NULL DEFAULT 1,
  `history_days` int NOT NULL DEFAULT 7,
  `can_view_sensor` tinyint NOT NULL DEFAULT 1,
  `can_operate` tinyint NOT NULL DEFAULT 1,
  `operation_whitelist` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JSON数组',
  `max_daily_operations` int NOT NULL DEFAULT 3,
  `shareable` tinyint NOT NULL DEFAULT 0,
  `created_by_user_id` bigint NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_bind_user_id`(`bind_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10004 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '认养码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of adoption_code
-- ----------------------------
INSERT INTO `adoption_code` VALUES (10001, 'LSGJ-MASTER-001', 'master', 20001, 30001, 50001, 3, 'active', '2026-01-01 00:00:00', '2026-12-31 23:59:59', '06:00:00', '23:00:00', 1, 1, 30, 1, 1, '[\"irrigation_apply\",\"fertilize_apply\",\"spray_apply\"]', 5, 1, NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `adoption_code` VALUES (10002, 'LSGJ-GUEST-001', 'guest', 20001, 30001, 50001, NULL, 'active', '2026-01-01 00:00:00', '2026-12-31 23:59:59', '08:00:00', '22:00:00', 1, 0, 0, 1, 0, '[]', 0, 0, NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `adoption_code` VALUES (10003, 'LSGJ-MASTER-002', 'master', 20002, 30002, 50002, NULL, 'active', '2026-01-01 00:00:00', '2026-12-31 23:59:59', '06:00:00', '23:00:00', 1, 1, 30, 1, 1, '[\"irrigation_apply\",\"fertilize_apply\"]', 3, 0, NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');

-- ----------------------------
-- Table structure for adoption_order
-- ----------------------------
DROP TABLE IF EXISTS `adoption_order`;
CREATE TABLE `adoption_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NULL DEFAULT NULL COMMENT '绑定用户',
  `plot_id` bigint NOT NULL,
  `crop_batch_id` bigint NULL DEFAULT NULL,
  `adoption_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'plot_crop',
  `order_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `start_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `visibility_level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'full',
  `operation_level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'request_only',
  `payable_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '应付金额',
  `pay_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'unpaid' COMMENT 'unpaid/paid/refunded',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人(管理员)ID',
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '认养订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of adoption_order
-- ----------------------------
INSERT INTO `adoption_order` VALUES (20001, 'AO-2026-00001', 3, 30001, 50001, 'plot_crop', 'active', '2026-01-01 00:00:00', '2026-12-31 23:59:59', 'full', 'request_only', NULL, 'unpaid', NULL, NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `adoption_order` VALUES (20002, 'AO-2026-00002', NULL, 30002, 50002, 'plot_crop', 'pending', '2026-01-01 00:00:00', '2026-12-31 23:59:59', 'full', 'request_only', NULL, 'unpaid', NULL, NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');

-- ----------------------------
-- Table structure for ai_analysis_record
-- ----------------------------
DROP TABLE IF EXISTS `ai_analysis_record`;
CREATE TABLE `ai_analysis_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plot_id` bigint NOT NULL,
  `analysis_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'periodic' COMMENT 'periodic/manual/alert',
  `sensor_snapshot` json NULL COMMENT '分析时的传感器数据快照',
  `crop_info` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作物信息摘要',
  `analysis_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'AI分析结论',
  `risk_level` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'low' COMMENT 'low/medium/high',
  `suggested_actions` json NULL COMMENT '建议操作列表',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_plot_time`(`plot_id` ASC, `created_at` DESC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI分析记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_analysis_record
-- ----------------------------
INSERT INTO `ai_analysis_record` VALUES (1, 30001, 'manual', '[{\"unit\": \"℃\", \"value\": 18.5, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}, {\"unit\": \"%\", \"value\": 45.2, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤湿度传感器\", \"sensorType\": \"soil_humidity\"}, {\"unit\": \"pH\", \"value\": 6.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤pH传感器\", \"sensorType\": \"soil_ph\"}, {\"unit\": \"℃\", \"value\": 22.3, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"空气温湿度传感器\", \"sensorType\": \"air_temperature\"}]', '作物:冬小麦(陇春27号) 生长阶段:heading 播种:2025-10-15 08:00:00 预计收获:2026-06-20 08:00:00 备注:即将进入灌浆期，需注意灌溉 风险:近期气温偏高，注意防旱', '数据存在时效性问题，影响分析准确性。当前土壤湿度适宜，土壤温度和空气温度适宜作物生长，土壤pH值适中。作物处于灌浆期，需注意灌溉以应对近期气温偏高可能导致的干旱风险。', 'medium', '[\"- 建议浇水：由于气温偏高，近期需注意防旱，保持土壤湿润有利于作物灌浆。\", \"- 建议检查灌溉系统：确保灌溉系统能够在需要时正常工作。\"]', '2026-04-14 22:24:06');
INSERT INTO `ai_analysis_record` VALUES (2, 30001, 'manual', '[{\"unit\": \"℃\", \"value\": 18.5, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}, {\"unit\": \"%\", \"value\": 45.2, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤湿度传感器\", \"sensorType\": \"soil_humidity\"}, {\"unit\": \"pH\", \"value\": 6.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤pH传感器\", \"sensorType\": \"soil_ph\"}, {\"unit\": \"℃\", \"value\": 22.3, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"空气温湿度传感器\", \"sensorType\": \"air_temperature\"}]', '作物:冬小麦(陇春27号) 生长阶段:heading 播种:2025-10-15 08:00:00 预计收获:2026-06-20 08:00:00 备注:即将进入灌浆期，需注意灌溉 风险:近期气温偏高，注意防旱', '当前土壤湿度适宜，土壤温度和空气温度适中，土壤pH值略酸性。作物处于灌浆期，需注意灌溉以防止干旱。', 'medium', '[\"- 建议浇水：[原因]近期气温偏高，注意防旱\", \"- 建议施肥：[原因]作物即将进入灌浆期，需补充营养\"]', '2026-04-14 22:40:34');
INSERT INTO `ai_analysis_record` VALUES (3, 30002, 'manual', '[{\"unit\": \"℃\", \"value\": 17.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}]', '作物:马铃薯(陇薯7号) 生长阶段:tuber_growth 播种:2026-03-01 08:00:00 预计收获:2026-07-15 08:00:00 备注:块茎膨大期，需追施钾肥 风险:无', '土壤温度传感器数据过时，无法准确判断作物生长环境。土壤湿度未提供，但基于土壤温度推测，作物可能处于适宜生长温度范围。土壤pH值信息缺失，无法判断是否需要调节。作物处于块茎膨大期，需追施钾肥。', 'medium', '[\"- 建议浇水：[土壤湿度信息缺失，需根据实际情况判断] → irrigation_apply\", \"- 建议施肥：[作物处于块茎膨大期，需追施钾肥] → fertilize_apply\"]', '2026-04-14 22:40:42');
INSERT INTO `ai_analysis_record` VALUES (4, 30001, 'periodic', '[{\"unit\": \"℃\", \"value\": 18.5, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}, {\"unit\": \"%\", \"value\": 45.2, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:54:45\", \"sensorName\": \"土壤湿度传感器\", \"sensorType\": \"soil_humidity\"}, {\"unit\": \"pH\", \"value\": 6.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤pH传感器\", \"sensorType\": \"soil_ph\"}, {\"unit\": \"℃\", \"value\": 22.3, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"空气温湿度传感器\", \"sensorType\": \"air_temperature\"}]', '作物:冬小麦(陇春27号) 生长阶段:heading 播种:2025-10-15 08:00:00 预计收获:2026-06-20 08:00:00 备注:即将进入灌浆期，需注意灌溉 风险:近期气温偏高，注意防旱', 'AI分析暂时不可用', 'low', '[]', '2026-04-15 06:00:01');
INSERT INTO `ai_analysis_record` VALUES (5, 30002, 'periodic', '[{\"unit\": \"℃\", \"value\": 17.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}]', '作物:马铃薯(陇薯7号) 生长阶段:tuber_growth 播种:2026-03-01 08:00:00 预计收获:2026-07-15 08:00:00 备注:块茎膨大期，需追施钾肥 风险:无', 'AI分析暂时不可用', 'low', '[]', '2026-04-15 06:00:04');
INSERT INTO `ai_analysis_record` VALUES (6, 30001, 'periodic', '[{\"unit\": \"℃\", \"value\": 18.5, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}, {\"unit\": \"%\", \"value\": 45.2, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:54:45\", \"sensorName\": \"土壤湿度传感器\", \"sensorType\": \"soil_humidity\"}, {\"unit\": \"pH\", \"value\": 6.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤pH传感器\", \"sensorType\": \"soil_ph\"}, {\"unit\": \"℃\", \"value\": 22.3, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"空气温湿度传感器\", \"sensorType\": \"air_temperature\"}]', '作物:冬小麦(陇春27号) 生长阶段:heading 播种:2025-10-15 08:00:00 预计收获:2026-06-20 08:00:00 备注:即将进入灌浆期，需注意灌溉 风险:近期气温偏高，注意防旱', '土壤湿度处于适宜范围，但传感器数据时效性差，影响灌溉判断。土壤温度、空气温度适宜作物生长。土壤pH值适中，无需调节。作物处于灌浆期，需关注灌溉以防止旱情。', 'medium', '[\"建议浇水：[原因]土壤湿度适宜，但数据时效性差，建议人工检查土壤湿度后再决定是否浇水\", \"注意防旱：[原因]近期气温偏高，作物即将进入灌浆期，需加强灌溉管理以防止旱情\"]', '2026-04-15 12:00:05');
INSERT INTO `ai_analysis_record` VALUES (7, 30002, 'periodic', '[{\"unit\": \"℃\", \"value\": 17.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}]', '作物:马铃薯(陇薯7号) 生长阶段:tuber_growth 播种:2026-03-01 08:00:00 预计收获:2026-07-15 08:00:00 备注:块茎膨大期，需追施钾肥 风险:无', '土壤温度数据过时，当前土壤湿度适宜，但土壤温度数据不可靠，建议关注作物生长环境。由于数据质量问题，分析结果可能存在偏差。', 'medium', '[\"- 建议浇水：当前土壤湿度适宜，但土壤温度数据不可靠，可能影响马铃薯块茎膨大。\", \"- 建议施肥：马铃薯处于块茎膨大期，需追施钾肥，建议及时施肥。\", \"- 建议喷淋：由于数据质量问题，不推荐进行喷淋操作。\"]', '2026-04-15 12:00:14');
INSERT INTO `ai_analysis_record` VALUES (8, 30001, 'periodic', '[{\"unit\": \"℃\", \"value\": 18.5, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}, {\"unit\": \"%\", \"value\": 45.2, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:54:45\", \"sensorName\": \"土壤湿度传感器\", \"sensorType\": \"soil_humidity\"}, {\"unit\": \"pH\", \"value\": 6.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"土壤pH传感器\", \"sensorType\": \"soil_ph\"}, {\"unit\": \"℃\", \"value\": 22.3, \"status\": \"online\", \"sampleAt\": \"2026-04-14 22:32:07\", \"sensorName\": \"空气温湿度传感器\", \"sensorType\": \"air_temperature\"}]', '作物:冬小麦(陇春27号) 生长阶段:heading 播种:2025-10-15 08:00:00 预计收获:2026-06-20 08:00:00 备注:即将进入灌浆期，需注意灌溉 风险:近期气温偏高，注意防旱', '当前土壤湿度适宜，但土壤温度、pH值及空气温湿度数据过时，可能导致判断不准确。土壤湿度为45.20%，处于适宜范围。土壤温度18.50℃，空气温度22.30℃，作物处于灌浆期，需适量灌溉。土壤pH值为6.80，接近中性，无需调节。由于数据过时，建议人工核实传感器数据。', 'medium', '[\"- 建议浇水：作物处于灌浆期，土壤湿度适宜，但需适量灌溉以保证充足水分\", \"- 建议检查土壤温度和pH值传感器数据：数据过时，需人工核实\"]', '2026-04-15 18:00:07');
INSERT INTO `ai_analysis_record` VALUES (9, 30002, 'periodic', '[{\"unit\": \"℃\", \"value\": 17.8, \"status\": \"online\", \"sampleAt\": \"2026-04-14 20:00:00\", \"sensorName\": \"土壤温度传感器\", \"sensorType\": \"soil_temperature\"}]', '作物:马铃薯(陇薯7号) 生长阶段:tuber_growth 播种:2026-03-01 08:00:00 预计收获:2026-07-15 08:00:00 备注:块茎膨大期，需追施钾肥 风险:无', '当前土壤湿度适宜，但土壤温度传感器数据过时，可能影响灌溉决策。空气温度未提供，无法判断作物生长环境。土壤pH值未提供，无法判断是否需要调节。马铃薯处于块茎膨大期，需关注钾肥施用。数据质量警告需注意。', 'medium', '[\"- 建议浇水：土壤湿度适宜，但需关注过时的土壤温度数据，适时调整灌溉计划\", \"- 建议施肥：马铃薯处于块茎膨大期，需追施钾肥\"]', '2026-04-15 18:00:15');

-- ----------------------------
-- Table structure for camera_device
-- ----------------------------
DROP TABLE IF EXISTS `camera_device`;
CREATE TABLE `camera_device`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `camera_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `plot_id` bigint NOT NULL,
  `stream_protocol` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'webrtc',
  `playback_enabled` tinyint NOT NULL DEFAULT 1,
  `ptz_enabled` tinyint NOT NULL DEFAULT 0,
  `mic_enabled` tinyint NOT NULL DEFAULT 0,
  `network_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'online',
  `device_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'online',
  `snapshot_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `rtmp_push_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `stream_app` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'live',
  `stream_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_device_no`(`device_no` ASC) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60007 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '摄像头设备表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of camera_device
-- ----------------------------
INSERT INTO `camera_device` VALUES (60001, 'CAM-A001-01', 'A区1号田全景摄像头', 30001, 'webrtc', 1, 1, 0, 'online', 'online', 'https://cdn.stub.com/snapshot-a001-01.jpg', NULL, 'live', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `camera_device` VALUES (60002, 'CAM-A001-02', 'A区1号田近景摄像头', 30001, 'webrtc', 1, 0, 0, 'online', 'online', 'https://cdn.stub.com/snapshot-a001-02.jpg', NULL, 'live', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `camera_device` VALUES (60003, 'CAM-A002-01', 'A区2号田全景摄像头', 30002, 'webrtc', 1, 0, 0, 'online', 'online', 'https://cdn.stub.com/snapshot-a002-01.jpg', NULL, 'live', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `camera_device` VALUES (60004, 'CAM-DM01', '1号棚球形摄像机', 40001, 'rtmp', 1, 1, 0, 'online', 'online', NULL, 'rtmp://localhost:1935/live/CAM-DM01', 'live', 'CAM-DM01', 0, '2026-04-16 04:36:42', '2026-04-16 20:07:06');
INSERT INTO `camera_device` VALUES (60005, 'CAM-DM02', '2号棚球形摄像机', 40006, 'rtmp', 1, 1, 0, 'online', 'online', NULL, 'rtmp://localhost:1935/live/CAM-DM02', 'live', 'CAM-DM02', 0, '2026-04-16 04:36:42', '2026-04-16 20:07:06');
INSERT INTO `camera_device` VALUES (60006, 'CAM-DM03', '3号棚球形摄像机', 40009, 'rtmp', 1, 1, 0, 'offline', 'offline', NULL, 'rtmp://localhost:1935/live/CAM-DM03', 'live', 'CAM-DM03', 0, '2026-04-16 04:36:42', '2026-04-16 20:07:06');
