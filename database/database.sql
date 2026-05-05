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

-- ----------------------------
-- Table structure for crop_batch
-- ----------------------------
DROP TABLE IF EXISTS `crop_batch`;
CREATE TABLE `crop_batch`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `plot_id` bigint NOT NULL,
  `crop_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `variety_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `growth_stage` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `batch_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `sowing_at` datetime NULL DEFAULT NULL,
  `expected_harvest_at` datetime NULL DEFAULT NULL,
  `next_task` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `risk_hint` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_batch_no`(`batch_no` ASC) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50003 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '作物批次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of crop_batch
-- ----------------------------
INSERT INTO `crop_batch` VALUES (50001, 'CB-2026-A001-01', 30001, '冬小麦', '陇春27号', 'heading', 'active', '2025-10-15 08:00:00', '2026-06-20 08:00:00', '即将进入灌浆期，需注意灌溉', '近期气温偏高，注意防旱', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `crop_batch` VALUES (50002, 'CB-2026-A002-01', 30002, '马铃薯', '陇薯7号', 'tuber_growth', 'active', '2026-03-01 08:00:00', '2026-07-15 08:00:00', '块茎膨大期，需追施钾肥', NULL, 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');

-- ----------------------------
-- Table structure for device_execution_log
-- ----------------------------
DROP TABLE IF EXISTS `device_execution_log`;
CREATE TABLE `device_execution_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `device_id` bigint NOT NULL,
  `device_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `command_payload` json NULL COMMENT 'MQTT command sent',
  `callback_payload` json NULL COMMENT 'device callback result',
  `execution_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'dispatched',
  `sensor_before` json NULL COMMENT 'sensor readings before execution',
  `sensor_after` json NULL COMMENT 'sensor readings after execution',
  `actual_duration_seconds` int NULL DEFAULT NULL COMMENT 'actual execution duration in seconds',
  `dispatched_at` datetime NOT NULL,
  `callback_at` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE,
  INDEX `idx_device_id`(`device_id` ASC) USING BTREE,
  INDEX `idx_dispatched_at`(`dispatched_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'device execution log' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_execution_log
-- ----------------------------

-- ----------------------------
-- Table structure for device_lock
-- ----------------------------
DROP TABLE IF EXISTS `device_lock`;
CREATE TABLE `device_lock`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_id` bigint NOT NULL,
  `current_task_id` bigint NULL DEFAULT NULL,
  `lock_owner` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `locked_at` datetime NULL DEFAULT NULL,
  `lock_expire_at` datetime NULL DEFAULT NULL,
  `lock_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'free' COMMENT 'free/locked',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_device_id`(`device_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_lock
-- ----------------------------
INSERT INTO `device_lock` VALUES (1, 80001, 5, 'task-5', '2026-04-14 22:54:17', '2026-04-14 23:24:17', 'free', '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `device_lock` VALUES (2, 80002, NULL, NULL, NULL, NULL, 'free', '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `device_lock` VALUES (3, 80003, NULL, NULL, NULL, NULL, 'free', '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `device_lock` VALUES (28, 80004, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (29, 80005, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (30, 80006, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (31, 80007, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (32, 80008, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (33, 80009, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (34, 80010, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (35, 80011, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (36, 80012, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (37, 80013, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (38, 80014, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `device_lock` VALUES (39, 80015, NULL, NULL, NULL, NULL, 'free', '2026-04-16 04:36:42', '2026-04-16 04:36:42');

-- ----------------------------
-- Table structure for edge_node
-- ----------------------------
DROP TABLE IF EXISTS `edge_node`;
CREATE TABLE `edge_node`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `node_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `farm_id` bigint NOT NULL DEFAULT 1,
  `node_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `hardware_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `os_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `runtime_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `network_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'online',
  `health_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'healthy',
  `local_storage_free_mb` bigint NULL DEFAULT NULL,
  `last_heartbeat_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_node_no`(`node_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '边缘节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of edge_node
-- ----------------------------
INSERT INTO `edge_node` VALUES (1, 'EDGE-001', 1, '陇上基地边缘节点01', 'RK3588', 'Ubuntu 22.04', 'Java 17', 'online', 'healthy', 32000, '2026-04-14 20:50:00', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');

-- ----------------------------
-- Table structure for farming_record
-- ----------------------------
DROP TABLE IF EXISTS `farming_record`;
CREATE TABLE `farming_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plot_id` bigint NOT NULL,
  `crop_batch_id` bigint NULL DEFAULT NULL,
  `record_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `record_title` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `record_time` datetime NOT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '农事记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of farming_record
-- ----------------------------
INSERT INTO `farming_record` VALUES (1, 30001, 50001, 'sowing', '播种冬小麦', '李运营', '2025-10-15 09:00:00', '使用陇春27号品种，每亩播种量15公斤', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `farming_record` VALUES (2, 30001, 50001, 'irrigation', '越冬灌溉', '李运营', '2025-12-01 10:00:00', '越冬前灌足底墒水，每亩灌水60方', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `farming_record` VALUES (3, 30001, 50001, 'fertilize', '返青追肥', '李运营', '2026-03-05 08:30:00', '每亩追施尿素10公斤', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `farming_record` VALUES (4, 30001, 50001, 'pest_control', '蚜虫防治', '王农技', '2026-04-01 14:00:00', '发现少量蚜虫，喷施吡虫啉', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');
INSERT INTO `farming_record` VALUES (5, 30002, 50002, 'sowing', '播种马铃薯', '李运营', '2026-03-01 09:00:00', '使用陇薯7号，切块催芽后播种', 0, '2026-04-14 21:34:33', '2026-04-14 21:34:33');

-- ----------------------------
-- Table structure for operation_task
-- ----------------------------
DROP TABLE IF EXISTS `operation_task`;
CREATE TABLE `operation_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_user_id` bigint NOT NULL,
  `plot_id` bigint NOT NULL,
  `device_id` bigint NOT NULL,
  `action_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_params` json NULL,
  `scheduling_mode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'queue',
  `expected_execute_at` datetime NULL DEFAULT NULL,
  `idempotency_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `priority` int NOT NULL DEFAULT 10,
  `task_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `device_execution_state` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'submitted',
  `queue_no` int NULL DEFAULT NULL,
  `estimated_wait_minutes` int NULL DEFAULT NULL,
  `fail_reason` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cancelable` tinyint NOT NULL DEFAULT 1,
  `queued_at` datetime NULL DEFAULT NULL,
  `started_at` datetime NULL DEFAULT NULL,
  `finished_at` datetime NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_task_no`(`task_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_idempotency_key`(`idempotency_key` ASC) USING BTREE,
  INDEX `idx_user_id`(`request_user_id` ASC) USING BTREE,
  INDEX `idx_device_status`(`device_id` ASC, `task_status` ASC) USING BTREE,
  INDEX `idx_plot_status`(`plot_id` ASC, `task_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_task
-- ----------------------------
INSERT INTO `operation_task` VALUES (1, 'T2044047795324829696', 3, 30001, 80001, 'irrigation_apply', NULL, 'immediate', NULL, 'e2e-test-003', 10, 'cancelled', 'success', NULL, NULL, NULL, 0, NULL, '2026-04-14 21:39:06', '2026-04-14 21:39:09', 0, '2026-04-14 21:39:06', '2026-04-14 22:32:33');
INSERT INTO `operation_task` VALUES (2, 'T2044053301921644544', 3, 30001, 80001, 'irrigation_apply', '{\"duration\": 300}', 'queue', NULL, 'ai-3-30001-irrigation_apply-f19b92be', 10, 'cancelled', 'success', NULL, NULL, NULL, 0, NULL, '2026-04-14 22:00:59', '2026-04-14 22:01:02', 0, '2026-04-14 22:00:59', '2026-04-14 22:32:33');
INSERT INTO `operation_task` VALUES (3, 'T2044059299214299136', 3, 30001, 80001, 'irrigation_apply', '{\"duration\": 300}', 'queue', NULL, 'ai-3-30001-irrigation_apply-405f1b67', 10, 'cancelled', 'success', NULL, NULL, NULL, 0, NULL, '2026-04-14 22:24:48', '2026-04-14 22:24:51', 0, '2026-04-14 22:24:48', '2026-04-14 22:32:33');
INSERT INTO `operation_task` VALUES (4, 'T2044059320454254592', 3, 30001, 80001, 'irrigation_apply', '{\"duration\": 300}', 'queue', NULL, 'ai-3-30001-irrigation_apply-daeb7590', 10, 'cancelled', 'success', NULL, NULL, NULL, 0, NULL, '2026-04-14 22:24:53', '2026-04-14 22:24:56', 0, '2026-04-14 22:24:53', '2026-04-14 22:32:33');
INSERT INTO `operation_task` VALUES (5, 'T2044066717625270272', 3, 30001, 80001, 'irrigation_apply', '{\"duration\": 300}', 'queue', NULL, 'ai-fix1-test-30001-irrigation_apply', 10, 'cancelled', 'running', NULL, NULL, NULL, 0, NULL, '2026-04-14 22:54:17', NULL, 0, '2026-04-14 22:54:17', '2026-04-14 22:54:17');

-- ----------------------------
-- Table structure for operation_task_queue
-- ----------------------------
DROP TABLE IF EXISTS `operation_task_queue`;
CREATE TABLE `operation_task_queue`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `device_id` bigint NOT NULL,
  `plot_id` bigint NOT NULL,
  `priority` int NOT NULL DEFAULT 10,
  `queued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expire_at` datetime NULL DEFAULT NULL,
  `task_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'queued',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_device_priority`(`device_id` ASC, `priority` ASC, `queued_at` ASC) USING BTREE,
  INDEX `idx_task_id`(`task_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务队列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_task_queue
-- ----------------------------

-- ----------------------------
-- Table structure for plot
-- ----------------------------
DROP TABLE IF EXISTS `plot`;
CREATE TABLE `plot`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plot_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `plot_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `farm_id` bigint NOT NULL DEFAULT 1,
  `farm_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '陇上基地',
  `parent_id` bigint NULL DEFAULT NULL,
  `area_size` decimal(10, 2) NULL DEFAULT NULL,
  `area_unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'mu',
  `longitude` decimal(12, 8) NULL DEFAULT NULL,
  `latitude` decimal(12, 8) NULL DEFAULT NULL,
  `plot_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `live_cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `intro_text` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plot_no`(`plot_no` ASC) USING BTREE,
  INDEX `idx_plot_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40014 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '地块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plot
-- ----------------------------
INSERT INTO `plot` VALUES (30001, 'PLOT-A001', 'A区1号田', 1, '稻梦田园', NULL, 2.50, 'mu', 104.06573500, 35.73116400, 'active', 'https://cdn.stub.com/plot-a001-cover.jpg', '位于陇上基地东侧，土壤肥沃，适合种植小麦和土豆', 0, '2026-04-14 21:34:33', '2026-04-16 06:28:34');
INSERT INTO `plot` VALUES (30002, 'PLOT-A002', 'A区2号田', 1, '稻梦田园', NULL, 3.00, 'mu', 104.06600000, 35.73120000, 'active', 'https://cdn.stub.com/plot-a002-cover.jpg', '位于陇上基地西侧，日照充足', 0, '2026-04-14 21:34:33', '2026-04-16 06:28:34');
INSERT INTO `plot` VALUES (30003, 'PLOT-DM01', '1号大棚', 1, '稻梦田园', NULL, 2.00, 'mu', 112.49230000, 27.91560000, 'active', NULL, '韶山市银田镇稻梦田园1号智慧大棚', 0, '2026-04-16 04:36:42', '2026-04-16 04:37:19');
INSERT INTO `plot` VALUES (30004, 'PLOT-DM02', '2号大棚', 1, '稻梦田园', NULL, 1.80, 'mu', 112.49250000, 27.91580000, 'active', NULL, '韶山市银田镇稻梦田园2号智慧大棚', 0, '2026-04-16 04:36:42', '2026-04-16 04:37:20');
INSERT INTO `plot` VALUES (30005, 'PLOT-DM03', '3号大棚', 1, '稻梦田园', NULL, 2.20, 'mu', 112.49270000, 27.91600000, 'active', NULL, '韶山市银田镇稻梦田园3号智慧大棚', 0, '2026-04-16 04:36:42', '2026-04-16 04:37:20');
INSERT INTO `plot` VALUES (40001, 'PT-DM01-01', '1#点位', 1, '稻梦田园', 30003, NULL, 'mu', NULL, NULL, 'active', NULL, '1号大棚桁架点位', 0, '2026-04-16 20:06:38', '2026-04-16 20:06:38');
INSERT INTO `plot` VALUES (40002, 'PT-DM01-02', '2#点位', 1, '稻梦田园', 30003, NULL, 'mu', NULL, NULL, 'active', NULL, '1号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:38', '2026-04-16 20:06:38');
INSERT INTO `plot` VALUES (40003, 'PT-DM01-03', '3#点位', 1, '稻梦田园', 30003, NULL, 'mu', NULL, NULL, 'active', NULL, '1号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:38', '2026-04-16 20:06:38');
INSERT INTO `plot` VALUES (40004, 'PT-DM01-04', '4#点位', 1, '稻梦田园', 30003, NULL, 'mu', NULL, NULL, 'active', NULL, '1号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:38', '2026-04-16 20:06:38');
INSERT INTO `plot` VALUES (40005, 'PT-DM01-05', '5#点位', 1, '稻梦田园', 30003, NULL, 'mu', NULL, NULL, 'active', NULL, '1号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:38', '2026-04-16 20:06:38');
INSERT INTO `plot` VALUES (40006, 'PT-DM02-06', '6#点位', 1, '稻梦田园', 30004, NULL, 'mu', NULL, NULL, 'active', NULL, '2号大棚桁架点位', 0, '2026-04-16 20:06:44', '2026-04-16 20:06:44');
INSERT INTO `plot` VALUES (40007, 'PT-DM02-07', '7#点位', 1, '稻梦田园', 30004, NULL, 'mu', NULL, NULL, 'active', NULL, '2号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:44', '2026-04-16 20:06:44');
INSERT INTO `plot` VALUES (40008, 'PT-DM02-08', '8#点位', 1, '稻梦田园', 30004, NULL, 'mu', NULL, NULL, 'active', NULL, '2号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:44', '2026-04-16 20:06:44');
INSERT INTO `plot` VALUES (40009, 'PT-DM03-09', '9#点位', 1, '稻梦田园', 30005, NULL, 'mu', NULL, NULL, 'active', NULL, '3号大棚桁架点位', 0, '2026-04-16 20:06:52', '2026-04-16 20:06:52');
INSERT INTO `plot` VALUES (40010, 'PT-DM03-10', '10#点位', 1, '稻梦田园', 30005, NULL, 'mu', NULL, NULL, 'active', NULL, '3号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:52', '2026-04-16 20:06:52');
INSERT INTO `plot` VALUES (40011, 'PT-DM03-11', '11#点位', 1, '稻梦田园', 30005, NULL, 'mu', NULL, NULL, 'active', NULL, '3号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:52', '2026-04-16 20:06:52');
INSERT INTO `plot` VALUES (40012, 'PT-DM03-12', '12#点位', 1, '稻梦田园', 30005, NULL, 'mu', NULL, NULL, 'active', NULL, '3号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:52', '2026-04-16 20:06:52');
INSERT INTO `plot` VALUES (40013, 'PT-DM03-13', '13#点位', 1, '稻梦田园', 30005, NULL, 'mu', NULL, NULL, 'active', NULL, '3号大棚棚壁土壤监测点', 0, '2026-04-16 20:06:52', '2026-04-16 20:06:52');

-- ----------------------------
-- Table structure for screen_device
-- ----------------------------
DROP TABLE IF EXISTS `screen_device`;
CREATE TABLE `screen_device`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `screen_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `plot_id` bigint NOT NULL,
  `screen_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `layout_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'offline',
  `last_ping_at` timestamp NULL DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_screen_device_no`(`device_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_screen_token`(`screen_token` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 90004 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of screen_device
-- ----------------------------
INSERT INTO `screen_device` VALUES (90001, 'SCR-DM01', '1号大棚展示屏', 30003, 'tk-dm01-a1b2c3d4e5f6', NULL, 'online', '2026-04-21 21:07:52', 0, '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `screen_device` VALUES (90002, 'SCR-DM02', '2号大棚展示屏', 30004, 'tk-dm02-f6e5d4c3b2a1', NULL, 'offline', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:36:42');
INSERT INTO `screen_device` VALUES (90003, 'SCR-DM03', '3号大棚展示屏', 30005, 'tk-dm03-1a2b3c4d5e6f', NULL, 'offline', NULL, 0, '2026-04-16 04:36:42', '2026-04-16 04:36:42');

-- ----------------------------
-- Table structure for sensor_data
-- ----------------------------
DROP TABLE IF EXISTS `sensor_data`;
CREATE TABLE `sensor_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sensor_id` bigint NOT NULL,
  `plot_id` bigint NOT NULL,
  `sensor_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `value` decimal(10, 2) NOT NULL,
  `sample_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sensor_time`(`sensor_id` ASC, `sample_at` ASC) USING BTREE,
  INDEX `idx_plot_type_time`(`plot_id` ASC, `sensor_type` ASC, `sample_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 928 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '传感器采样数据表' ROW_FORMAT = Dynamic;
-- ----------------------------
-- Records of sensor_data
-- ----------------------------
INSERT INTO `sensor_data` VALUES (1, 70001, 30001, 'soil_temperature', 17.20, '2026-04-14 14:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (2, 70001, 30001, 'soil_temperature', 17.80, '2026-04-14 15:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (3, 70001, 30001, 'soil_temperature', 18.10, '2026-04-14 16:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (4, 70001, 30001, 'soil_temperature', 18.30, '2026-04-14 17:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (5, 70001, 30001, 'soil_temperature', 18.50, '2026-04-14 18:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (6, 70001, 30001, 'soil_temperature', 18.40, '2026-04-14 19:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (7, 70001, 30001, 'soil_temperature', 18.50, '2026-04-14 20:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (8, 70002, 30001, 'soil_humidity', 42.00, '2026-04-14 14:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (9, 70002, 30001, 'soil_humidity', 43.50, '2026-04-14 16:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (10, 70002, 30001, 'soil_humidity', 44.80, '2026-04-14 18:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (11, 70002, 30001, 'soil_humidity', 45.20, '2026-04-14 20:00:00', '2026-04-14 21:34:33');
INSERT INTO `sensor_data` VALUES (12, 70001, 30001, '钾', 5.20, '2026-04-15 23:17:00', '2026-04-15 23:38:28');
INSERT INTO `sensor_data` VALUES (13, 70001, 30001, '氮', 3.10, '2026-04-15 23:17:00', '2026-04-15 23:38:28');
INSERT INTO `sensor_data` VALUES (14, 70001, 30001, 'pH', 6.80, '2026-04-15 23:17:00', '2026-04-15 23:38:28');
INSERT INTO `sensor_data` VALUES (15, 70010, 40001, 'temperature', 26.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (16, 70010, 40001, 'humidity', 72.30, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (17, 70010, 40001, 'light', 15200.00, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (18, 70010, 40001, 'CO2', 418.00, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (19, 70010, 40001, 'temperature', 26.20, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (20, 70010, 40001, 'humidity', 73.10, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (21, 70010, 40001, 'light', 14800.00, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (22, 70010, 40001, 'CO2', 425.00, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (23, 70010, 40001, 'temperature', 25.80, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (24, 70010, 40001, 'humidity', 74.50, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (25, 70010, 40001, 'light', 12500.00, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (26, 70010, 40001, 'CO2', 430.00, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (27, 70010, 40001, 'temperature', 25.30, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (28, 70010, 40001, 'humidity', 75.20, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (29, 70010, 40001, 'light', 10200.00, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (30, 70010, 40001, 'CO2', 435.00, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (31, 70010, 40001, 'temperature', 24.80, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (32, 70010, 40001, 'humidity', 76.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (33, 70010, 40001, 'light', 8500.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (34, 70010, 40001, 'CO2', 440.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (35, 70010, 40001, 'temperature', 24.20, '2026-04-16 01:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (36, 70010, 40001, 'humidity', 77.50, '2026-04-16 01:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (37, 70010, 40001, 'light', 5000.00, '2026-04-16 01:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (38, 70010, 40001, 'CO2', 448.00, '2026-04-16 01:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (39, 70010, 40001, 'temperature', 23.50, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (40, 70010, 40001, 'humidity', 78.80, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (41, 70010, 40001, 'light', 2200.00, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (42, 70010, 40001, 'CO2', 455.00, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (43, 70010, 40001, 'temperature', 23.00, '2026-04-16 00:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (44, 70010, 40001, 'humidity', 79.50, '2026-04-16 00:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (45, 70010, 40001, 'light', 800.00, '2026-04-16 00:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (46, 70010, 40001, 'CO2', 460.00, '2026-04-16 00:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (47, 70011, 40006, 'temperature', 25.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (48, 70011, 40006, 'humidity', 68.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (49, 70011, 40006, 'light', 14500.00, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (50, 70011, 40006, 'CO2', 412.00, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (51, 70011, 40006, 'temperature', 25.50, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (52, 70011, 40006, 'humidity', 69.20, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (53, 70011, 40006, 'light', 13800.00, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (54, 70011, 40006, 'CO2', 420.00, '2026-04-16 03:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (55, 70011, 40006, 'temperature', 25.00, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (56, 70011, 40006, 'humidity', 70.10, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (57, 70011, 40006, 'light', 11200.00, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (58, 70011, 40006, 'CO2', 428.00, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (59, 70011, 40006, 'temperature', 24.30, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (60, 70011, 40006, 'humidity', 71.80, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (61, 70011, 40006, 'light', 9000.00, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (62, 70011, 40006, 'CO2', 435.00, '2026-04-16 02:30:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (63, 70011, 40006, 'temperature', 23.80, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (64, 70011, 40006, 'humidity', 73.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (65, 70011, 40006, 'light', 6800.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (66, 70011, 40006, 'CO2', 442.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (67, 70020, 40002, 'N', 3.10, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (68, 70020, 40002, 'P', 1.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (69, 70020, 40002, 'K', 5.20, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (70, 70020, 40002, 'N', 3.05, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (71, 70020, 40002, 'P', 1.75, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (72, 70020, 40002, 'K', 5.15, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (73, 70020, 40002, 'N', 3.00, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (74, 70020, 40002, 'P', 1.70, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (75, 70020, 40002, 'K', 5.10, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (76, 70020, 40002, 'N', 2.95, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (77, 70020, 40002, 'P', 1.65, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (78, 70020, 40002, 'K', 5.05, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (79, 70021, 40007, 'N', 2.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (80, 70021, 40007, 'P', 1.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (81, 70021, 40007, 'K', 4.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (82, 70021, 40007, 'N', 2.75, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (83, 70021, 40007, 'P', 1.45, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (84, 70021, 40007, 'K', 4.70, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (85, 70022, 40010, 'N', 3.30, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (86, 70022, 40010, 'P', 2.10, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (87, 70022, 40010, 'K', 5.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (88, 70022, 40010, 'N', 3.25, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (89, 70022, 40010, 'P', 2.05, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (90, 70022, 40010, 'K', 5.45, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (91, 70030, 40002, 'pH', 6.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (92, 70030, 40002, 'pH', 6.82, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (93, 70030, 40002, 'pH', 6.78, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (94, 70030, 40002, 'pH', 6.85, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (95, 70031, 40007, 'pH', 7.10, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (96, 70031, 40007, 'pH', 7.05, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (97, 70031, 40007, 'pH', 7.12, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (98, 70032, 40010, 'pH', 6.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (99, 70032, 40010, 'pH', 6.55, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (100, 70040, 40002, 'soilTemp', 22.50, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (101, 70040, 40002, 'soilMoisture', 65.30, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (102, 70040, 40002, 'soilTemp', 22.20, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (103, 70040, 40002, 'soilMoisture', 64.80, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (104, 70040, 40002, 'soilTemp', 21.80, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (105, 70040, 40002, 'soilMoisture', 64.20, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (106, 70040, 40002, 'soilTemp', 21.50, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (107, 70040, 40002, 'soilMoisture', 63.50, '2026-04-16 01:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (108, 70041, 40007, 'soilTemp', 21.80, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (109, 70041, 40007, 'soilMoisture', 58.70, '2026-04-16 04:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (110, 70041, 40007, 'soilTemp', 21.50, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (111, 70041, 40007, 'soilMoisture', 57.90, '2026-04-16 03:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (112, 70041, 40007, 'soilTemp', 21.20, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (113, 70041, 40007, 'soilMoisture', 57.10, '2026-04-16 02:00:00', '2026-04-16 04:36:42');
INSERT INTO `sensor_data` VALUES (114, 70010, 40001, 'temperature', 27.30, '2026-04-16 21:56:00', '2026-04-16 21:56:54');
INSERT INTO `sensor_data` VALUES (115, 70010, 40001, 'humidity', 74.10, '2026-04-16 21:56:00', '2026-04-16 21:56:54');
INSERT INTO `sensor_data` VALUES (116, 70010, 40001, 'light', 18500.00, '2026-04-16 21:56:00', '2026-04-16 21:56:54');
INSERT INTO `sensor_data` VALUES (117, 70010, 40001, 'CO2', 435.00, '2026-04-16 21:56:00', '2026-04-16 21:56:54');
INSERT INTO `sensor_data` VALUES (118, 70010, 40001, 'temperature', 27.30, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (119, 70010, 40001, 'humidity', 74.10, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (120, 70010, 40001, 'light', 18500.00, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (121, 70010, 40001, 'CO2', 435.00, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (122, 70020, 40002, 'N', 3.50, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (123, 70020, 40002, 'P', 2.10, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (124, 70020, 40002, 'K', 5.80, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (125, 70030, 40002, 'pH', 6.90, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (126, 70040, 40002, 'soilTemp', 23.10, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (127, 70040, 40002, 'soilMoisture', 67.20, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (128, 70011, 40006, 'temperature', 25.80, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (129, 70011, 40006, 'humidity', 68.50, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (130, 70011, 40006, 'light', 14500.00, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (131, 70011, 40006, 'CO2', 412.00, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (132, 70021, 40007, 'N', 2.80, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (133, 70021, 40007, 'P', 1.50, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (134, 70021, 40007, 'K', 4.80, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (135, 70031, 40007, 'pH', 7.10, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (136, 70041, 40007, 'soilTemp', 21.80, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (137, 70041, 40007, 'soilMoisture', 58.70, '2026-04-16 21:59:12', '2026-04-16 21:59:12');
INSERT INTO `sensor_data` VALUES (138, 70012, 40009, 'temperature', 26.10, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (139, 70012, 40009, 'humidity', 71.80, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (140, 70012, 40009, 'light', 16800.00, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (141, 70012, 40009, 'CO2', 428.00, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (142, 70022, 40010, 'N', 3.20, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (143, 70022, 40010, 'P', 1.90, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (144, 70022, 40010, 'K', 5.50, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (145, 70032, 40010, 'pH', 6.50, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (146, 70042, 40010, 'soilTemp', 22.40, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (147, 70042, 40010, 'soilMoisture', 63.10, '2026-04-16 21:59:12', '2026-04-16 21:59:13');
INSERT INTO `sensor_data` VALUES (148, 70010, 40001, 'temperature', 25.70, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (149, 70010, 40001, 'humidity', 76.80, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (150, 70010, 40001, 'light', 19544.70, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (151, 70010, 40001, 'CO2', 423.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (152, 70020, 40002, 'N', 3.00, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (153, 70020, 40002, 'P', 2.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (154, 70020, 40002, 'K', 6.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (155, 70030, 40002, 'pH', 6.60, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (156, 70040, 40002, 'soilTemp', 21.80, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (157, 70040, 40002, 'soilMoisture', 65.50, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (158, 70011, 40006, 'temperature', 26.60, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (159, 70011, 40006, 'humidity', 73.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (160, 70011, 40006, 'light', 13937.10, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (161, 70011, 40006, 'CO2', 415.00, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (162, 70021, 40007, 'N', 2.60, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (163, 70021, 40007, 'P', 1.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (164, 70021, 40007, 'K', 4.50, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (165, 70031, 40007, 'pH', 6.80, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (166, 70041, 40007, 'soilTemp', 23.00, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (167, 70041, 40007, 'soilMoisture', 60.00, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (168, 70012, 40009, 'temperature', 25.30, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (169, 70012, 40009, 'humidity', 73.20, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (170, 70012, 40009, 'light', 18754.70, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (171, 70012, 40009, 'CO2', 439.80, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (172, 70022, 40010, 'N', 3.10, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (173, 70022, 40010, 'P', 2.00, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (174, 70022, 40010, 'K', 5.10, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (175, 70032, 40010, 'pH', 6.60, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (176, 70042, 40010, 'soilTemp', 22.80, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (177, 70042, 40010, 'soilMoisture', 63.40, '2026-04-16 22:00:59', '2026-04-16 22:00:59');
INSERT INTO `sensor_data` VALUES (178, 70010, 40001, 'temperature', 27.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (179, 70010, 40001, 'humidity', 69.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (180, 70010, 40001, 'light', 16590.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (181, 70010, 40001, 'CO2', 452.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (182, 70020, 40002, 'N', 3.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (183, 70020, 40002, 'P', 1.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (184, 70020, 40002, 'K', 5.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (185, 70030, 40002, 'pH', 6.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (186, 70040, 40002, 'soilTemp', 24.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (187, 70040, 40002, 'soilMoisture', 64.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (188, 70043, 40003, 'N', 3.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (189, 70043, 40003, 'P', 1.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (190, 70043, 40003, 'K', 5.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (191, 70044, 40003, 'pH', 6.60, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (192, 70045, 40003, 'soilTemp', 23.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (193, 70045, 40003, 'soilMoisture', 64.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (194, 70046, 40004, 'N', 4.10, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (195, 70046, 40004, 'P', 1.90, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (196, 70046, 40004, 'K', 6.40, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (197, 70047, 40004, 'pH', 6.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (198, 70048, 40004, 'soilTemp', 23.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (199, 70048, 40004, 'soilMoisture', 67.30, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (200, 70049, 40005, 'N', 2.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (201, 70049, 40005, 'P', 1.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (202, 70049, 40005, 'K', 5.40, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (203, 70050, 40005, 'pH', 6.90, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (204, 70051, 40005, 'soilTemp', 23.80, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (205, 70051, 40005, 'soilMoisture', 60.60, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (206, 70011, 40006, 'temperature', 25.10, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (207, 70011, 40006, 'humidity', 72.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (208, 70011, 40006, 'light', 14813.30, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (209, 70011, 40006, 'CO2', 391.10, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (210, 70021, 40007, 'N', 2.40, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (211, 70021, 40007, 'P', 1.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (212, 70021, 40007, 'K', 4.30, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (213, 70031, 40007, 'pH', 7.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (214, 70041, 40007, 'soilTemp', 21.90, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (215, 70041, 40007, 'soilMoisture', 55.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (216, 70052, 40008, 'N', 2.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (217, 70052, 40008, 'P', 1.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (218, 70052, 40008, 'K', 4.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (219, 70053, 40008, 'pH', 7.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (220, 70054, 40008, 'soilTemp', 22.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (221, 70054, 40008, 'soilMoisture', 54.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (222, 70012, 40009, 'temperature', 25.50, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (223, 70012, 40009, 'humidity', 70.30, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (224, 70012, 40009, 'light', 16837.20, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (225, 70012, 40009, 'CO2', 409.30, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (226, 70022, 40010, 'N', 3.00, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (227, 70022, 40010, 'P', 1.90, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (228, 70022, 40010, 'K', 5.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (229, 70032, 40010, 'pH', 6.70, '2026-04-16 22:04:49', '2026-04-16 22:04:49');
INSERT INTO `sensor_data` VALUES (230, 70042, 40010, 'soilTemp', 21.60, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (231, 70042, 40010, 'soilMoisture', 61.30, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (232, 70055, 40011, 'N', 3.10, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (233, 70055, 40011, 'P', 1.90, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (234, 70055, 40011, 'K', 5.20, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (235, 70056, 40011, 'pH', 6.60, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (236, 70057, 40011, 'soilTemp', 23.20, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (237, 70057, 40011, 'soilMoisture', 60.20, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (238, 70058, 40012, 'N', 3.70, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (239, 70058, 40012, 'P', 2.20, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (240, 70058, 40012, 'K', 5.30, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (241, 70059, 40012, 'pH', 6.70, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (242, 70060, 40012, 'soilTemp', 21.90, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (243, 70060, 40012, 'soilMoisture', 63.90, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (244, 70061, 40013, 'N', 3.40, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (245, 70061, 40013, 'P', 1.60, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (246, 70061, 40013, 'K', 5.60, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (247, 70062, 40013, 'pH', 6.70, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (248, 70063, 40013, 'soilTemp', 23.70, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (249, 70063, 40013, 'soilMoisture', 65.20, '2026-04-16 22:04:49', '2026-04-16 22:04:50');
INSERT INTO `sensor_data` VALUES (250, 70010, 40001, 'temperature', 99.90, '2026-04-16 22:47:14', '2026-04-16 22:47:15');
INSERT INTO `sensor_data` VALUES (251, 70010, 40001, 'temperature', 25.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (252, 70010, 40001, 'humidity', 77.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (253, 70010, 40001, 'light', 15650.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (254, 70010, 40001, 'CO2', 404.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (255, 70020, 40002, 'N', 4.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (256, 70020, 40002, 'P', 2.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (257, 70020, 40002, 'K', 5.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (258, 70030, 40002, 'pH', 6.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (259, 70040, 40002, 'soilTemp', 24.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (260, 70040, 40002, 'soilMoisture', 67.50, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (261, 70043, 40003, 'N', 3.50, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (262, 70043, 40003, 'P', 1.80, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (263, 70043, 40003, 'K', 5.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (264, 70044, 40003, 'pH', 6.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (265, 70045, 40003, 'soilTemp', 22.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (266, 70045, 40003, 'soilMoisture', 63.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (267, 70046, 40004, 'N', 3.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (268, 70046, 40004, 'P', 2.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (269, 70046, 40004, 'K', 6.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (270, 70047, 40004, 'pH', 6.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (271, 70048, 40004, 'soilTemp', 22.40, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (272, 70048, 40004, 'soilMoisture', 64.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (273, 70049, 40005, 'N', 3.50, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (274, 70049, 40005, 'P', 2.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (275, 70049, 40005, 'K', 5.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (276, 70050, 40005, 'pH', 7.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (277, 70051, 40005, 'soilTemp', 21.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (278, 70051, 40005, 'soilMoisture', 64.50, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (279, 70011, 40006, 'temperature', 24.70, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (280, 70011, 40006, 'humidity', 70.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (281, 70011, 40006, 'light', 14159.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (282, 70011, 40006, 'CO2', 409.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (283, 70021, 40007, 'N', 3.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (284, 70021, 40007, 'P', 1.70, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (285, 70021, 40007, 'K', 4.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (286, 70031, 40007, 'pH', 7.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (287, 70041, 40007, 'soilTemp', 20.80, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (288, 70041, 40007, 'soilMoisture', 60.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (289, 70052, 40008, 'N', 2.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (290, 70052, 40008, 'P', 1.50, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (291, 70052, 40008, 'K', 4.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (292, 70053, 40008, 'pH', 7.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (293, 70054, 40008, 'soilTemp', 21.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (294, 70054, 40008, 'soilMoisture', 58.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (295, 70012, 40009, 'temperature', 27.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (296, 70012, 40009, 'humidity', 76.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (297, 70012, 40009, 'light', 13621.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (298, 70012, 40009, 'CO2', 419.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (299, 70022, 40010, 'N', 3.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (300, 70022, 40010, 'P', 1.80, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (301, 70022, 40010, 'K', 5.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (302, 70032, 40010, 'pH', 6.40, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (303, 70042, 40010, 'soilTemp', 22.60, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (304, 70042, 40010, 'soilMoisture', 63.80, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (305, 70055, 40011, 'N', 3.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (306, 70055, 40011, 'P', 1.80, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (307, 70055, 40011, 'K', 5.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (308, 70056, 40011, 'pH', 6.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (309, 70057, 40011, 'soilTemp', 22.70, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (310, 70057, 40011, 'soilMoisture', 58.40, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (311, 70058, 40012, 'N', 3.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (312, 70058, 40012, 'P', 2.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (313, 70058, 40012, 'K', 6.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (314, 70059, 40012, 'pH', 6.10, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (315, 70060, 40012, 'soilTemp', 24.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (316, 70060, 40012, 'soilMoisture', 64.00, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (317, 70061, 40013, 'N', 3.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (318, 70061, 40013, 'P', 1.30, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (319, 70061, 40013, 'K', 5.20, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (320, 70062, 40013, 'pH', 6.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (321, 70063, 40013, 'soilTemp', 23.70, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (322, 70063, 40013, 'soilMoisture', 59.90, '2026-04-19 12:23:33', '2026-04-19 12:23:34');
INSERT INTO `sensor_data` VALUES (323, 70010, 40001, 'temperature', 25.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (324, 70010, 40001, 'humidity', 73.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (325, 70010, 40001, 'light', 19141.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (326, 70010, 40001, 'CO2', 444.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (327, 70020, 40002, 'N', 3.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (328, 70020, 40002, 'P', 2.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (329, 70020, 40002, 'K', 6.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (330, 70030, 40002, 'pH', 6.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (331, 70040, 40002, 'soilTemp', 23.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (332, 70040, 40002, 'soilMoisture', 67.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (333, 70043, 40003, 'N', 3.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (334, 70043, 40003, 'P', 1.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (335, 70043, 40003, 'K', 5.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (336, 70044, 40003, 'pH', 6.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (337, 70045, 40003, 'soilTemp', 22.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (338, 70045, 40003, 'soilMoisture', 66.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (339, 70046, 40004, 'N', 3.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (340, 70046, 40004, 'P', 2.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (341, 70046, 40004, 'K', 5.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (342, 70047, 40004, 'pH', 6.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (343, 70048, 40004, 'soilTemp', 24.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (344, 70048, 40004, 'soilMoisture', 66.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (345, 70049, 40005, 'N', 2.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (346, 70049, 40005, 'P', 1.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (347, 70049, 40005, 'K', 4.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (348, 70050, 40005, 'pH', 6.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (349, 70051, 40005, 'soilTemp', 21.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (350, 70051, 40005, 'soilMoisture', 61.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (351, 70011, 40006, 'temperature', 24.00, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (352, 70011, 40006, 'humidity', 72.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (353, 70011, 40006, 'light', 11630.00, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (354, 70011, 40006, 'CO2', 419.00, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (355, 70021, 40007, 'N', 2.70, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (356, 70021, 40007, 'P', 1.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (357, 70021, 40007, 'K', 4.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (358, 70031, 40007, 'pH', 7.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (359, 70041, 40007, 'soilTemp', 21.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (360, 70041, 40007, 'soilMoisture', 59.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (361, 70052, 40008, 'N', 2.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (362, 70052, 40008, 'P', 1.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (363, 70052, 40008, 'K', 4.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (364, 70053, 40008, 'pH', 7.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (365, 70054, 40008, 'soilTemp', 22.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (366, 70054, 40008, 'soilMoisture', 58.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (367, 70012, 40009, 'temperature', 26.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (368, 70012, 40009, 'humidity', 76.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (369, 70012, 40009, 'light', 16954.70, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (370, 70012, 40009, 'CO2', 420.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (371, 70022, 40010, 'N', 2.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (372, 70022, 40010, 'P', 2.20, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (373, 70022, 40010, 'K', 4.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (374, 70032, 40010, 'pH', 6.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (375, 70042, 40010, 'soilTemp', 22.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (376, 70042, 40010, 'soilMoisture', 66.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (377, 70055, 40011, 'N', 2.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (378, 70055, 40011, 'P', 1.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (379, 70055, 40011, 'K', 4.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (380, 70056, 40011, 'pH', 6.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (381, 70057, 40011, 'soilTemp', 21.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (382, 70057, 40011, 'soilMoisture', 62.30, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (383, 70058, 40012, 'N', 3.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (384, 70058, 40012, 'P', 2.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (385, 70058, 40012, 'K', 5.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (386, 70059, 40012, 'pH', 6.50, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (387, 70060, 40012, 'soilTemp', 22.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (388, 70060, 40012, 'soilMoisture', 65.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (389, 70061, 40013, 'N', 2.80, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (390, 70061, 40013, 'P', 1.60, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (391, 70061, 40013, 'K', 4.90, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (392, 70062, 40013, 'pH', 7.00, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (393, 70063, 40013, 'soilTemp', 23.10, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (394, 70063, 40013, 'soilMoisture', 59.40, '2026-04-19 12:24:03', '2026-04-19 12:24:04');
INSERT INTO `sensor_data` VALUES (395, 70010, 40001, 'temperature', 26.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (396, 70010, 40001, 'humidity', 76.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (397, 70010, 40001, 'light', 16972.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (398, 70010, 40001, 'CO2', 420.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (399, 70020, 40002, 'N', 3.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (400, 70020, 40002, 'P', 1.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (401, 70020, 40002, 'K', 5.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (402, 70030, 40002, 'pH', 7.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (403, 70040, 40002, 'soilTemp', 23.00, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (404, 70040, 40002, 'soilMoisture', 65.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (405, 70043, 40003, 'N', 3.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (406, 70043, 40003, 'P', 1.50, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (407, 70043, 40003, 'K', 5.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (408, 70044, 40003, 'pH', 6.60, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (409, 70045, 40003, 'soilTemp', 22.70, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (410, 70045, 40003, 'soilMoisture', 60.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (411, 70046, 40004, 'N', 3.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (412, 70046, 40004, 'P', 2.30, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (413, 70046, 40004, 'K', 6.60, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (414, 70047, 40004, 'pH', 6.50, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (415, 70048, 40004, 'soilTemp', 24.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (416, 70048, 40004, 'soilMoisture', 70.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (417, 70049, 40005, 'N', 3.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (418, 70049, 40005, 'P', 2.00, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (419, 70049, 40005, 'K', 4.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (420, 70050, 40005, 'pH', 7.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (421, 70051, 40005, 'soilTemp', 23.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (422, 70051, 40005, 'soilMoisture', 59.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (423, 70011, 40006, 'temperature', 25.60, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (424, 70011, 40006, 'humidity', 65.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (425, 70011, 40006, 'light', 13051.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (426, 70011, 40006, 'CO2', 419.50, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (427, 70021, 40007, 'N', 2.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (428, 70021, 40007, 'P', 1.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (429, 70021, 40007, 'K', 5.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (430, 70031, 40007, 'pH', 6.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (431, 70041, 40007, 'soilTemp', 22.60, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (432, 70041, 40007, 'soilMoisture', 61.60, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (433, 70052, 40008, 'N', 2.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (434, 70052, 40008, 'P', 1.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (435, 70052, 40008, 'K', 4.70, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (436, 70053, 40008, 'pH', 7.30, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (437, 70054, 40008, 'soilTemp', 20.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (438, 70054, 40008, 'soilMoisture', 56.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (439, 70012, 40009, 'temperature', 25.70, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (440, 70012, 40009, 'humidity', 72.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (441, 70012, 40009, 'light', 19082.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (442, 70012, 40009, 'CO2', 440.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (443, 70022, 40010, 'N', 2.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (444, 70022, 40010, 'P', 1.70, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (445, 70022, 40010, 'K', 5.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (446, 70032, 40010, 'pH', 6.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (447, 70042, 40010, 'soilTemp', 21.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (448, 70042, 40010, 'soilMoisture', 66.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (449, 70055, 40011, 'N', 3.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (450, 70055, 40011, 'P', 1.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (451, 70055, 40011, 'K', 5.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (452, 70056, 40011, 'pH', 6.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (453, 70057, 40011, 'soilTemp', 21.70, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (454, 70057, 40011, 'soilMoisture', 64.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (455, 70058, 40012, 'N', 3.20, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (456, 70058, 40012, 'P', 2.00, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (457, 70058, 40012, 'K', 5.40, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (458, 70059, 40012, 'pH', 6.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (459, 70060, 40012, 'soilTemp', 23.50, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (460, 70060, 40012, 'soilMoisture', 68.80, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (461, 70061, 40013, 'N', 2.50, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (462, 70061, 40013, 'P', 1.30, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (463, 70061, 40013, 'K', 4.30, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (464, 70062, 40013, 'pH', 6.90, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (465, 70063, 40013, 'soilTemp', 23.30, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (466, 70063, 40013, 'soilMoisture', 60.10, '2026-04-19 12:24:33', '2026-04-19 12:24:34');
INSERT INTO `sensor_data` VALUES (467, 70010, 40001, 'temperature', 25.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (468, 70010, 40001, 'humidity', 70.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (469, 70010, 40001, 'light', 19484.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (470, 70010, 40001, 'CO2', 432.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (471, 70020, 40002, 'N', 3.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (472, 70020, 40002, 'P', 1.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (473, 70020, 40002, 'K', 5.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (474, 70030, 40002, 'pH', 7.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (475, 70040, 40002, 'soilTemp', 22.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (476, 70040, 40002, 'soilMoisture', 64.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (477, 70043, 40003, 'N', 3.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (478, 70043, 40003, 'P', 1.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (479, 70043, 40003, 'K', 5.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (480, 70044, 40003, 'pH', 6.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (481, 70045, 40003, 'soilTemp', 24.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (482, 70045, 40003, 'soilMoisture', 61.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (483, 70046, 40004, 'N', 4.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (484, 70046, 40004, 'P', 2.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (485, 70046, 40004, 'K', 5.70, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (486, 70047, 40004, 'pH', 6.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (487, 70048, 40004, 'soilTemp', 22.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (488, 70048, 40004, 'soilMoisture', 64.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (489, 70049, 40005, 'N', 3.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (490, 70049, 40005, 'P', 1.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (491, 70049, 40005, 'K', 4.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (492, 70050, 40005, 'pH', 7.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (493, 70051, 40005, 'soilTemp', 21.20, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (494, 70051, 40005, 'soilMoisture', 61.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (495, 70011, 40006, 'temperature', 24.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (496, 70011, 40006, 'humidity', 64.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (497, 70011, 40006, 'light', 12267.70, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (498, 70011, 40006, 'CO2', 405.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (499, 70021, 40007, 'N', 2.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (500, 70021, 40007, 'P', 1.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (501, 70021, 40007, 'K', 4.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (502, 70031, 40007, 'pH', 7.20, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (503, 70041, 40007, 'soilTemp', 23.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (504, 70041, 40007, 'soilMoisture', 58.70, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (505, 70052, 40008, 'N', 2.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (506, 70052, 40008, 'P', 1.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (507, 70052, 40008, 'K', 5.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (508, 70053, 40008, 'pH', 7.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (509, 70054, 40008, 'soilTemp', 20.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (510, 70054, 40008, 'soilMoisture', 53.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (511, 70012, 40009, 'temperature', 25.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (512, 70012, 40009, 'humidity', 71.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (513, 70012, 40009, 'light', 13627.20, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (514, 70012, 40009, 'CO2', 449.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (515, 70022, 40010, 'N', 3.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (516, 70022, 40010, 'P', 2.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (517, 70022, 40010, 'K', 5.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (518, 70032, 40010, 'pH', 6.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (519, 70042, 40010, 'soilTemp', 22.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (520, 70042, 40010, 'soilMoisture', 62.50, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (521, 70055, 40011, 'N', 2.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (522, 70055, 40011, 'P', 2.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (523, 70055, 40011, 'K', 5.30, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (524, 70056, 40011, 'pH', 6.70, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (525, 70057, 40011, 'soilTemp', 23.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (526, 70057, 40011, 'soilMoisture', 59.10, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (527, 70058, 40012, 'N', 3.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (528, 70058, 40012, 'P', 1.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (529, 70058, 40012, 'K', 6.20, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (530, 70059, 40012, 'pH', 6.40, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (531, 70060, 40012, 'soilTemp', 24.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (532, 70060, 40012, 'soilMoisture', 68.90, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (533, 70061, 40013, 'N', 2.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (534, 70061, 40013, 'P', 1.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (535, 70061, 40013, 'K', 4.60, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (536, 70062, 40013, 'pH', 6.80, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (537, 70063, 40013, 'soilTemp', 22.70, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (538, 70063, 40013, 'soilMoisture', 63.00, '2026-04-19 12:25:03', '2026-04-19 12:25:04');
INSERT INTO `sensor_data` VALUES (539, 70010, 40001, 'temperature', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:53:44');
INSERT INTO `sensor_data` VALUES (540, 70010, 40001, 'humidity', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:53:44');
INSERT INTO `sensor_data` VALUES (541, 70010, 40001, 'light', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:53:44');
INSERT INTO `sensor_data` VALUES (542, 70010, 40001, 'CO2', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:53:44');
INSERT INTO `sensor_data` VALUES (543, 70010, 40001, 'temperature', 28.10, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (544, 70010, 40001, 'humidity', 71.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (545, 70010, 40001, 'light', 15565.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (546, 70010, 40001, 'CO2', 401.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (547, 70020, 40002, 'N', 3.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (548, 70020, 40002, 'P', 1.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (549, 70020, 40002, 'K', 5.00, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (550, 70030, 40002, 'pH', 7.10, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (551, 70040, 40002, 'soilTemp', 23.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (552, 70040, 40002, 'soilMoisture', 69.00, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (553, 70043, 40003, 'N', 3.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (554, 70043, 40003, 'P', 1.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (555, 70043, 40003, 'K', 5.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (556, 70044, 40003, 'pH', 6.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (557, 70045, 40003, 'soilTemp', 22.20, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (558, 70045, 40003, 'soilMoisture', 61.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (559, 70046, 40004, 'N', 3.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (560, 70046, 40004, 'P', 2.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (561, 70046, 40004, 'K', 6.20, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (562, 70047, 40004, 'pH', 6.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (563, 70048, 40004, 'soilTemp', 21.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (564, 70048, 40004, 'soilMoisture', 69.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (565, 70049, 40005, 'N', 3.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (566, 70049, 40005, 'P', 2.00, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (567, 70049, 40005, 'K', 5.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (568, 70050, 40005, 'pH', 7.00, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (569, 70051, 40005, 'soilTemp', 22.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (570, 70051, 40005, 'soilMoisture', 63.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (571, 70011, 40006, 'temperature', 23.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (572, 70011, 40006, 'humidity', 65.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (573, 70011, 40006, 'light', 13582.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (574, 70011, 40006, 'CO2', 429.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (575, 70021, 40007, 'N', 2.50, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (576, 70021, 40007, 'P', 1.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (577, 70021, 40007, 'K', 5.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (578, 70031, 40007, 'pH', 7.10, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (579, 70041, 40007, 'soilTemp', 21.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (580, 70041, 40007, 'soilMoisture', 54.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (581, 70052, 40008, 'N', 2.20, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (582, 70052, 40008, 'P', 1.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (583, 70052, 40008, 'K', 5.10, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (584, 70053, 40008, 'pH', 7.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (585, 70054, 40008, 'soilTemp', 21.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (586, 70054, 40008, 'soilMoisture', 55.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (587, 70012, 40009, 'temperature', 26.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (588, 70012, 40009, 'humidity', 74.50, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (589, 70012, 40009, 'light', 15955.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (590, 70012, 40009, 'CO2', 450.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (591, 70022, 40010, 'N', 2.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (592, 70022, 40010, 'P', 2.20, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (593, 70022, 40010, 'K', 5.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (594, 70032, 40010, 'pH', 6.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (595, 70042, 40010, 'soilTemp', 23.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (596, 70042, 40010, 'soilMoisture', 66.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (597, 70055, 40011, 'N', 3.00, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (598, 70055, 40011, 'P', 1.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (599, 70055, 40011, 'K', 5.10, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (600, 70056, 40011, 'pH', 6.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (601, 70057, 40011, 'soilTemp', 21.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (602, 70057, 40011, 'soilMoisture', 60.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (603, 70058, 40012, 'N', 3.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (604, 70058, 40012, 'P', 1.90, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (605, 70058, 40012, 'K', 5.20, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (606, 70059, 40012, 'pH', 6.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (607, 70060, 40012, 'soilTemp', 24.40, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (608, 70060, 40012, 'soilMoisture', 66.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (609, 70061, 40013, 'N', 3.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (610, 70061, 40013, 'P', 1.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (611, 70061, 40013, 'K', 4.30, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (612, 70062, 40013, 'pH', 6.70, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (613, 70063, 40013, 'soilTemp', 22.60, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (614, 70063, 40013, 'soilMoisture', 59.80, '2026-04-19 13:57:45', '2026-04-19 13:57:46');
INSERT INTO `sensor_data` VALUES (615, 70010, 40001, 'temperature', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:58:57');
INSERT INTO `sensor_data` VALUES (616, 70010, 40001, 'humidity', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:58:57');
INSERT INTO `sensor_data` VALUES (617, 70010, 40001, 'light', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:58:57');
INSERT INTO `sensor_data` VALUES (618, 70010, 40001, 'CO2', 1.00, '2026-04-19 12:00:00', '2026-04-19 13:58:57');
INSERT INTO `sensor_data` VALUES (619, 70010, 40001, 'N', 3.50, '2026-04-19 12:00:00', '2026-04-19 13:59:31');
INSERT INTO `sensor_data` VALUES (620, 70010, 40001, 'P', 2.10, '2026-04-19 12:00:00', '2026-04-19 13:59:31');
INSERT INTO `sensor_data` VALUES (621, 70010, 40001, 'K', 5.80, '2026-04-19 12:00:00', '2026-04-19 13:59:31');
INSERT INTO `sensor_data` VALUES (622, 70010, 40001, 'pH', 6.90, '2026-04-19 12:00:00', '2026-04-19 14:02:50');
INSERT INTO `sensor_data` VALUES (623, 70010, 40001, 'temperature', 27.30, '2026-04-19 12:00:00', '2026-04-19 14:07:44');
INSERT INTO `sensor_data` VALUES (624, 70010, 40001, 'humidity', 74.10, '2026-04-19 12:00:00', '2026-04-19 14:07:44');
INSERT INTO `sensor_data` VALUES (625, 70010, 40001, 'light', 18500.00, '2026-04-19 12:00:00', '2026-04-19 14:07:44');
INSERT INTO `sensor_data` VALUES (626, 70010, 40001, 'CO2', 435.00, '2026-04-19 12:00:00', '2026-04-19 14:07:44');
INSERT INTO `sensor_data` VALUES (627, 70010, 40001, 'temperature', 1.30, '2026-04-19 14:09:36', '2026-04-19 14:09:36');
INSERT INTO `sensor_data` VALUES (628, 70010, 40001, 'humidity', 71.00, '2026-04-19 14:09:36', '2026-04-19 14:09:36');
INSERT INTO `sensor_data` VALUES (629, 70010, 40001, 'light', 110.00, '2026-04-19 14:09:36', '2026-04-19 14:09:36');
INSERT INTO `sensor_data` VALUES (630, 70010, 40001, 'CO2', 1.00, '2026-04-19 14:09:36', '2026-04-19 14:09:36');
INSERT INTO `sensor_data` VALUES (631, 70020, 40002, 'N', 3.50, '2026-04-19 12:00:00', '2026-04-19 14:14:35');
INSERT INTO `sensor_data` VALUES (632, 70020, 40002, 'P', 2.10, '2026-04-19 12:00:00', '2026-04-19 14:14:35');
INSERT INTO `sensor_data` VALUES (633, 70020, 40002, 'K', 5.80, '2026-04-19 12:00:00', '2026-04-19 14:14:35');
INSERT INTO `sensor_data` VALUES (634, 70010, 40001, 'temperature', 27.30, '2026-04-19 12:00:00', '2026-04-19 14:15:39');
INSERT INTO `sensor_data` VALUES (635, 70010, 40001, 'humidity', 74.10, '2026-04-19 12:00:00', '2026-04-19 14:15:39');
INSERT INTO `sensor_data` VALUES (636, 70010, 40001, 'light', 18500.00, '2026-04-19 12:00:00', '2026-04-19 14:15:39');
INSERT INTO `sensor_data` VALUES (637, 70010, 40001, 'CO2', 435.00, '2026-04-19 12:00:00', '2026-04-19 14:15:39');
INSERT INTO `sensor_data` VALUES (638, 70020, 40002, 'temperature', 27.30, '2026-04-19 12:00:00', '2026-04-19 14:19:01');
INSERT INTO `sensor_data` VALUES (639, 70020, 40002, 'humidity', 74.10, '2026-04-19 12:00:00', '2026-04-19 14:19:01');
INSERT INTO `sensor_data` VALUES (640, 70020, 40002, 'light', 18500.00, '2026-04-19 12:00:00', '2026-04-19 14:19:01');
INSERT INTO `sensor_data` VALUES (641, 70020, 40002, 'CO2', 435.00, '2026-04-19 12:00:00', '2026-04-19 14:19:01');
INSERT INTO `sensor_data` VALUES (642, 70020, 40002, 'temperature', 27.30, '2026-04-19 12:00:00', '2026-04-19 14:20:04');
INSERT INTO `sensor_data` VALUES (643, 70020, 40002, 'humidity', 74.10, '2026-04-19 12:00:00', '2026-04-19 14:20:04');
INSERT INTO `sensor_data` VALUES (644, 70020, 40002, 'light', 18500.00, '2026-04-19 12:00:00', '2026-04-19 14:20:04');
INSERT INTO `sensor_data` VALUES (645, 70020, 40002, 'CO2', 435.00, '2026-04-19 12:00:00', '2026-04-19 14:20:04');
INSERT INTO `sensor_data` VALUES (646, 70010, 40001, 'light', 77700.00, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (647, 70010, 40001, 'CO2', 666.00, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (648, 70010, 40001, 'temperature', 99.90, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (649, 70010, 40001, 'humidity', 88.80, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (650, 70020, 40002, 'P', 8.80, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (651, 70020, 40002, 'K', 7.70, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (652, 70020, 40002, 'N', 9.90, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (653, 70030, 40002, 'pH', 9.90, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (654, 70040, 40002, 'soilTemp', 99.90, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (655, 70040, 40002, 'soilMoisture', 88.80, '2026-04-19 14:54:38', '2026-04-19 14:54:38');
INSERT INTO `sensor_data` VALUES (656, 70010, 40001, 'light', 6133.00, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (657, 70010, 40001, 'CO2', 983.00, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (658, 70010, 40001, 'temperature', 58.43, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (659, 70010, 40001, 'humidity', 58.53, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (660, 70020, 40002, 'P', 6.03, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (661, 70020, 40002, 'K', 6.13, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (662, 70020, 40002, 'N', 5.93, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (663, 70030, 40002, 'pH', 11.83, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (664, 70040, 40002, 'soilTemp', 58.73, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (665, 70040, 40002, 'soilMoisture', 58.83, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (666, 70043, 40003, 'P', 6.13, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (667, 70043, 40003, 'K', 6.23, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (668, 70043, 40003, 'N', 6.03, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (669, 70044, 40003, 'pH', 11.93, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (670, 70045, 40003, 'soilTemp', 59.73, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (671, 70045, 40003, 'soilMoisture', 59.83, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (672, 70046, 40004, 'P', 6.23, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (673, 70046, 40004, 'K', 6.33, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (674, 70046, 40004, 'N', 6.13, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (675, 70047, 40004, 'pH', 12.03, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (676, 70048, 40004, 'soilTemp', 60.73, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (677, 70048, 40004, 'soilMoisture', 60.83, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (678, 70049, 40005, 'P', 6.33, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (679, 70049, 40005, 'K', 6.43, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (680, 70049, 40005, 'N', 6.23, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (681, 70050, 40005, 'pH', 12.13, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (682, 70051, 40005, 'soilTemp', 61.73, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (683, 70051, 40005, 'soilMoisture', 61.83, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (684, 70011, 40006, 'light', 6533.00, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (685, 70011, 40006, 'CO2', 1023.00, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (686, 70011, 40006, 'temperature', 62.43, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (687, 70011, 40006, 'humidity', 62.53, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (688, 70021, 40007, 'P', 6.43, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (689, 70021, 40007, 'K', 6.53, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (690, 70021, 40007, 'N', 6.33, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (691, 70031, 40007, 'pH', 12.23, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (692, 70041, 40007, 'soilTemp', 62.73, '2026-04-19 15:01:55', '2026-04-19 15:01:55');
INSERT INTO `sensor_data` VALUES (693, 70041, 40007, 'soilMoisture', 62.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (694, 70052, 40008, 'P', 6.53, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (695, 70052, 40008, 'K', 6.63, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (696, 70052, 40008, 'N', 6.43, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (697, 70053, 40008, 'pH', 12.33, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (698, 70054, 40008, 'soilTemp', 63.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (699, 70054, 40008, 'soilMoisture', 63.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (700, 70012, 40009, 'light', 6733.00, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (701, 70012, 40009, 'CO2', 1043.00, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (702, 70012, 40009, 'temperature', 64.43, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (703, 70012, 40009, 'humidity', 64.53, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (704, 70022, 40010, 'P', 6.63, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (705, 70022, 40010, 'K', 6.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (706, 70022, 40010, 'N', 6.53, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (707, 70032, 40010, 'pH', 12.43, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (708, 70042, 40010, 'soilTemp', 64.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (709, 70042, 40010, 'soilMoisture', 64.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (710, 70055, 40011, 'P', 6.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (711, 70055, 40011, 'K', 6.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (712, 70055, 40011, 'N', 6.63, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (713, 70056, 40011, 'pH', 12.53, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (714, 70057, 40011, 'soilTemp', 65.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (715, 70057, 40011, 'soilMoisture', 65.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (716, 70058, 40012, 'P', 6.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (717, 70058, 40012, 'K', 6.93, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (718, 70058, 40012, 'N', 6.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (719, 70059, 40012, 'pH', 12.63, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (720, 70060, 40012, 'soilTemp', 66.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (721, 70060, 40012, 'soilMoisture', 66.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (722, 70061, 40013, 'P', 6.93, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (723, 70061, 40013, 'K', 7.03, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (724, 70061, 40013, 'N', 6.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (725, 70062, 40013, 'pH', 12.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (726, 70063, 40013, 'soilTemp', 67.73, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (727, 70063, 40013, 'soilMoisture', 67.83, '2026-04-19 15:01:55', '2026-04-19 15:01:56');
INSERT INTO `sensor_data` VALUES (728, 70010, 40001, 'light', 9212.00, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (729, 70010, 40001, 'CO2', 1291.00, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (730, 70010, 40001, 'temperature', 89.22, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (731, 70010, 40001, 'humidity', 89.32, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (732, 70020, 40002, 'P', 9.11, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (733, 70020, 40002, 'K', 9.21, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (734, 70020, 40002, 'N', 9.01, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (735, 70030, 40002, 'pH', 14.91, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (736, 70040, 40002, 'soilTemp', 89.52, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (737, 70040, 40002, 'soilMoisture', 89.62, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (738, 70043, 40003, 'P', 9.21, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (739, 70043, 40003, 'K', 9.31, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (740, 70043, 40003, 'N', 9.11, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (741, 70044, 40003, 'pH', 15.01, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (742, 70045, 40003, 'soilTemp', 90.52, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (743, 70045, 40003, 'soilMoisture', 90.62, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (744, 70046, 40004, 'P', 9.31, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (745, 70046, 40004, 'K', 9.41, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (746, 70046, 40004, 'N', 9.21, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (747, 70047, 40004, 'pH', 15.11, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (748, 70048, 40004, 'soilTemp', 91.52, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (749, 70048, 40004, 'soilMoisture', 91.62, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (750, 70049, 40005, 'P', 9.41, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (751, 70049, 40005, 'K', 9.51, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (752, 70049, 40005, 'N', 9.31, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (753, 70050, 40005, 'pH', 15.21, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (754, 70051, 40005, 'soilTemp', 92.52, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (755, 70051, 40005, 'soilMoisture', 92.62, '2026-04-19 15:09:57', '2026-04-19 15:09:57');
INSERT INTO `sensor_data` VALUES (756, 70010, 40001, 'light', 8786.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (757, 70010, 40001, 'CO2', 1248.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (758, 70010, 40001, 'temperature', 84.96, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (759, 70010, 40001, 'humidity', 85.06, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (760, 70020, 40002, 'P', 8.69, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (761, 70020, 40002, 'K', 8.79, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (762, 70020, 40002, 'N', 8.59, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (763, 70030, 40002, 'pH', 14.49, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (764, 70040, 40002, 'soilTemp', 85.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (765, 70040, 40002, 'soilMoisture', 85.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (766, 70043, 40003, 'P', 8.79, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (767, 70043, 40003, 'K', 8.89, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (768, 70043, 40003, 'N', 8.69, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (769, 70044, 40003, 'pH', 14.59, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (770, 70045, 40003, 'soilTemp', 86.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (771, 70045, 40003, 'soilMoisture', 86.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (772, 70046, 40004, 'P', 8.89, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (773, 70046, 40004, 'K', 8.99, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (774, 70046, 40004, 'N', 8.79, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (775, 70047, 40004, 'pH', 14.69, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (776, 70048, 40004, 'soilTemp', 87.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (777, 70048, 40004, 'soilMoisture', 87.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (778, 70049, 40005, 'P', 8.99, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (779, 70049, 40005, 'K', 9.09, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (780, 70049, 40005, 'N', 8.89, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (781, 70050, 40005, 'pH', 14.79, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (782, 70051, 40005, 'soilTemp', 88.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (783, 70051, 40005, 'soilMoisture', 88.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (784, 70011, 40006, 'light', 9186.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (785, 70011, 40006, 'CO2', 1288.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (786, 70011, 40006, 'temperature', 88.96, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (787, 70011, 40006, 'humidity', 89.06, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (788, 70021, 40007, 'P', 9.09, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (789, 70021, 40007, 'K', 9.19, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (790, 70021, 40007, 'N', 8.99, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (791, 70031, 40007, 'pH', 14.89, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (792, 70041, 40007, 'soilTemp', 89.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (793, 70041, 40007, 'soilMoisture', 89.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (794, 70052, 40008, 'P', 9.19, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (795, 70052, 40008, 'K', 9.29, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (796, 70052, 40008, 'N', 9.09, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (797, 70053, 40008, 'pH', 14.99, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (798, 70054, 40008, 'soilTemp', 90.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (799, 70054, 40008, 'soilMoisture', 90.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (800, 70012, 40009, 'light', 9386.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (801, 70012, 40009, 'CO2', 1308.00, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (802, 70012, 40009, 'temperature', 90.96, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (803, 70012, 40009, 'humidity', 91.06, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (804, 70022, 40010, 'P', 9.29, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (805, 70022, 40010, 'K', 9.39, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (806, 70022, 40010, 'N', 9.19, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (807, 70032, 40010, 'pH', 15.09, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (808, 70042, 40010, 'soilTemp', 91.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (809, 70042, 40010, 'soilMoisture', 91.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (810, 70055, 40011, 'P', 9.39, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (811, 70055, 40011, 'K', 9.49, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (812, 70055, 40011, 'N', 9.29, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (813, 70056, 40011, 'pH', 15.19, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (814, 70057, 40011, 'soilTemp', 92.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (815, 70057, 40011, 'soilMoisture', 92.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (816, 70058, 40012, 'P', 9.49, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (817, 70058, 40012, 'K', 9.59, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (818, 70058, 40012, 'N', 9.39, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (819, 70059, 40012, 'pH', 15.29, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (820, 70060, 40012, 'soilTemp', 93.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (821, 70060, 40012, 'soilMoisture', 93.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (822, 70061, 40013, 'P', 9.59, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (823, 70061, 40013, 'K', 9.69, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (824, 70061, 40013, 'N', 9.49, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (825, 70062, 40013, 'pH', 15.39, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (826, 70063, 40013, 'soilTemp', 94.26, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (827, 70063, 40013, 'soilMoisture', 94.36, '2026-04-19 15:10:07', '2026-04-19 15:10:07');
INSERT INTO `sensor_data` VALUES (828, 70010, 40001, 'light', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (829, 70010, 40001, 'CO2', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (830, 70010, 40001, 'temperature', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (831, 70010, 40001, 'humidity', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (832, 70020, 40002, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (833, 70020, 40002, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (834, 70020, 40002, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (835, 70030, 40002, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (836, 70040, 40002, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (837, 70040, 40002, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (838, 70043, 40003, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (839, 70043, 40003, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (840, 70043, 40003, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (841, 70044, 40003, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (842, 70045, 40003, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (843, 70045, 40003, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (844, 70046, 40004, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (845, 70046, 40004, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (846, 70046, 40004, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (847, 70047, 40004, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (848, 70048, 40004, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (849, 70048, 40004, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (850, 70049, 40005, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (851, 70049, 40005, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (852, 70049, 40005, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (853, 70050, 40005, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (854, 70051, 40005, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (855, 70051, 40005, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (856, 70011, 40006, 'light', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (857, 70011, 40006, 'CO2', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (858, 70011, 40006, 'temperature', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (859, 70011, 40006, 'humidity', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (860, 70021, 40007, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (861, 70021, 40007, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (862, 70021, 40007, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (863, 70031, 40007, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (864, 70041, 40007, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (865, 70041, 40007, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (866, 70052, 40008, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (867, 70052, 40008, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (868, 70052, 40008, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (869, 70053, 40008, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (870, 70054, 40008, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (871, 70054, 40008, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (872, 70012, 40009, 'light', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (873, 70012, 40009, 'CO2', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (874, 70012, 40009, 'temperature', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (875, 70012, 40009, 'humidity', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (876, 70022, 40010, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (877, 70022, 40010, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (878, 70022, 40010, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (879, 70032, 40010, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (880, 70042, 40010, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (881, 70042, 40010, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (882, 70055, 40011, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (883, 70055, 40011, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (884, 70055, 40011, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (885, 70056, 40011, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (886, 70057, 40011, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (887, 70057, 40011, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (888, 70058, 40012, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (889, 70058, 40012, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (890, 70058, 40012, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (891, 70059, 40012, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (892, 70060, 40012, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (893, 70060, 40012, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (894, 70061, 40013, 'P', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (895, 70061, 40013, 'K', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (896, 70061, 40013, 'N', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (897, 70062, 40013, 'pH', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (898, 70063, 40013, 'soilTemp', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (899, 70063, 40013, 'soilMoisture', 100.00, '2026-04-19 15:16:49', '2026-04-19 15:16:49');
INSERT INTO `sensor_data` VALUES (900, 70010, 40001, 'light', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (901, 70010, 40001, 'CO2', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (902, 70010, 40001, 'temperature', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (903, 70010, 40001, 'humidity', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (904, 70020, 40002, 'P', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (905, 70020, 40002, 'K', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (906, 70020, 40002, 'N', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (907, 70030, 40002, 'pH', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (908, 70040, 40002, 'soilTemp', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (909, 70040, 40002, 'soilMoisture', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (910, 70043, 40003, 'P', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (911, 70043, 40003, 'K', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (912, 70043, 40003, 'N', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (913, 70044, 40003, 'pH', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (914, 70045, 40003, 'soilTemp', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (915, 70045, 40003, 'soilMoisture', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (916, 70046, 40004, 'P', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (917, 70046, 40004, 'K', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (918, 70046, 40004, 'N', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (919, 70047, 40004, 'pH', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (920, 70048, 40004, 'soilTemp', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (921, 70048, 40004, 'soilMoisture', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (922, 70049, 40005, 'P', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (923, 70049, 40005, 'K', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (924, 70049, 40005, 'N', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (925, 70050, 40005, 'pH', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (926, 70051, 40005, 'soilTemp', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');
INSERT INTO `sensor_data` VALUES (927, 70051, 40005, 'soilMoisture', 100.00, '2026-04-19 15:20:15', '2026-04-19 15:20:15');