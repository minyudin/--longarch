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

