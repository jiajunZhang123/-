/*
 Navicat Premium Dump SQL

 Source Server         : bendi
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : localhost:3306
 Source Schema         : shop_db

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 31/12/2025 15:08:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '管理员用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码（加密）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, 'admin', '$2y$10$tvrrCrwl4WBoCrl7bmHVEOFwBBFqfA4HQu.cEREZg1NzompwkyrvG', 'admin@example.com', '2025-12-31 11:22:39', '2025-12-31 11:22:39');

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_product`(`user_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  UNIQUE INDEX `UKl6khof9uhahjhyppoki8070gw`(`user_id` ASC, `product_id` ASC) USING BTREE,
  CONSTRAINT `fk_carts_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_carts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carts
-- ----------------------------

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称（快照）',
  `product_price` decimal(10, 2) NOT NULL COMMENT '商品价格（快照）',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '购买数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计金额',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_items_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_items_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单商品明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 1, 'iPhone 15 Pro', 7999.00, 1, 7999.00, '2025-12-31 11:25:02');
INSERT INTO `order_items` VALUES (2, 2, 1, 'iPhone 15 Pro', 7999.00, 2, 15998.00, '2025-12-31 14:41:35');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `user_id` int NOT NULL COMMENT '用户ID',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_orders_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 'ORD202512311125024630', 1, 7999.00, 3, '2025-12-31 11:25:02', '2025-12-31 14:41:49');
INSERT INTO `orders` VALUES (2, 'ORD202512311441345629', 1, 15998.00, 3, '2025-12-31 14:41:35', '2025-12-31 14:43:59');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品描述',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片路径',
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 'iPhone 15 Pro', '苹果最新款智能手机，配备A17 Pro芯片', 7999.00, 98, 'images/iphone15.png', 1, '2025-12-31 11:22:39', '2025-12-31 14:43:51');
INSERT INTO `products` VALUES (2, 'MacBook Pro 14', '14英寸MacBook Pro，M3芯片，16GB内存', 14999.00, 50, 'images/macbook.png', 1, '2025-12-31 11:22:39', '2025-12-31 11:30:20');
INSERT INTO `products` VALUES (3, 'AirPods Pro', '主动降噪无线耳机，空间音频', 1899.00, 200, 'images/airpods.png', 1, '2025-12-31 11:22:39', '2025-12-31 11:30:56');
INSERT INTO `products` VALUES (4, 'iPad Air', '10.9英寸iPad Air，M1芯片', 4399.00, 80, 'images/ipad.png', 1, '2025-12-31 11:22:39', '2025-12-31 11:31:23');
INSERT INTO `products` VALUES (5, 'Apple Watch Series 9', '智能手表，健康监测', 2999.00, 150, 'images/watch.png', 1, '2025-12-31 11:22:39', '2025-12-31 11:31:53');
INSERT INTO `products` VALUES (6, 'iPhone 15 Pro Max', '1200', 7999.00, 100, 'images/iphone15.png', 1, '2025-12-31 13:58:42', '2025-12-31 13:58:42');
INSERT INTO `products` VALUES (7, '测试', '测试航拍', 200.00, 200, '/images/a5cee508-443e-4e6e-9d9a-61218ed27441.png', 1, '2025-12-31 14:21:11', '2025-12-31 14:21:11');

-- ----------------------------
-- Table structure for user_logs
-- ----------------------------
DROP TABLE IF EXISTS `user_logs`;
CREATE TABLE `user_logs`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID（可为空，未登录用户）',
  `product_id` int NULL DEFAULT NULL COMMENT '商品ID',
  `action_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '行为类型：view-浏览，purchase-购买',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_action_type`(`action_type` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_user_logs_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 340 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户行为日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_logs
-- ----------------------------
INSERT INTO `user_logs` VALUES (1, 1, 1, 'view', '::1', '2025-12-31 11:24:27');
INSERT INTO `user_logs` VALUES (2, 1, 2, 'view', '::1', '2025-12-31 11:24:27');
INSERT INTO `user_logs` VALUES (3, 1, 3, 'view', '::1', '2025-12-31 11:24:27');
INSERT INTO `user_logs` VALUES (4, 1, 4, 'view', '::1', '2025-12-31 11:24:27');
INSERT INTO `user_logs` VALUES (5, 1, 5, 'view', '::1', '2025-12-31 11:24:27');
INSERT INTO `user_logs` VALUES (6, 1, 1, 'view', '::1', '2025-12-31 11:24:47');
INSERT INTO `user_logs` VALUES (7, 1, 2, 'view', '::1', '2025-12-31 11:24:47');
INSERT INTO `user_logs` VALUES (8, 1, 3, 'view', '::1', '2025-12-31 11:24:47');
INSERT INTO `user_logs` VALUES (9, 1, 4, 'view', '::1', '2025-12-31 11:24:47');
INSERT INTO `user_logs` VALUES (10, 1, 5, 'view', '::1', '2025-12-31 11:24:47');
INSERT INTO `user_logs` VALUES (11, 1, 1, 'purchase', '::1', '2025-12-31 11:25:02');
INSERT INTO `user_logs` VALUES (12, 1, 1, 'view', '::1', '2025-12-31 11:27:09');
INSERT INTO `user_logs` VALUES (13, 1, 2, 'view', '::1', '2025-12-31 11:27:09');
INSERT INTO `user_logs` VALUES (14, 1, 3, 'view', '::1', '2025-12-31 11:27:09');
INSERT INTO `user_logs` VALUES (15, 1, 4, 'view', '::1', '2025-12-31 11:27:09');
INSERT INTO `user_logs` VALUES (16, 1, 5, 'view', '::1', '2025-12-31 11:27:09');
INSERT INTO `user_logs` VALUES (17, 1, 1, 'view', '::1', '2025-12-31 11:28:58');
INSERT INTO `user_logs` VALUES (18, 1, 2, 'view', '::1', '2025-12-31 11:28:58');
INSERT INTO `user_logs` VALUES (19, 1, 3, 'view', '::1', '2025-12-31 11:28:58');
INSERT INTO `user_logs` VALUES (20, 1, 4, 'view', '::1', '2025-12-31 11:28:58');
INSERT INTO `user_logs` VALUES (21, 1, 5, 'view', '::1', '2025-12-31 11:28:58');
INSERT INTO `user_logs` VALUES (22, 1, 1, 'view', '::1', '2025-12-31 11:29:35');
INSERT INTO `user_logs` VALUES (23, 1, 2, 'view', '::1', '2025-12-31 11:29:35');
INSERT INTO `user_logs` VALUES (24, 1, 3, 'view', '::1', '2025-12-31 11:29:35');
INSERT INTO `user_logs` VALUES (25, 1, 4, 'view', '::1', '2025-12-31 11:29:35');
INSERT INTO `user_logs` VALUES (26, 1, 5, 'view', '::1', '2025-12-31 11:29:35');
INSERT INTO `user_logs` VALUES (27, 1, 1, 'view', '::1', '2025-12-31 11:29:36');
INSERT INTO `user_logs` VALUES (28, 1, 2, 'view', '::1', '2025-12-31 11:29:36');
INSERT INTO `user_logs` VALUES (29, 1, 3, 'view', '::1', '2025-12-31 11:29:36');
INSERT INTO `user_logs` VALUES (30, 1, 4, 'view', '::1', '2025-12-31 11:29:36');
INSERT INTO `user_logs` VALUES (31, 1, 5, 'view', '::1', '2025-12-31 11:29:36');
INSERT INTO `user_logs` VALUES (32, 1, 1, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (33, 1, 2, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (34, 1, 3, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (35, 1, 4, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (36, 1, 5, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (37, 1, 1, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (38, 1, 2, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (39, 1, 3, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (40, 1, 4, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (41, 1, 5, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (42, 1, 1, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (43, 1, 2, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (44, 1, 3, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (45, 1, 4, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (46, 1, 5, 'view', '::1', '2025-12-31 11:29:51');
INSERT INTO `user_logs` VALUES (47, 1, 1, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (48, 1, 2, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (49, 1, 3, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (50, 1, 4, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (51, 1, 5, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (52, 1, 1, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (53, 1, 2, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (54, 1, 3, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (55, 1, 4, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (56, 1, 5, 'view', '::1', '2025-12-31 11:30:05');
INSERT INTO `user_logs` VALUES (57, 1, 1, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (58, 1, 2, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (59, 1, 3, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (60, 1, 4, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (61, 1, 5, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (62, 1, 1, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (63, 1, 2, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (64, 1, 3, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (65, 1, 4, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (66, 1, 5, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (67, 1, 1, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (68, 1, 2, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (69, 1, 3, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (70, 1, 4, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (71, 1, 5, 'view', '::1', '2025-12-31 11:30:06');
INSERT INTO `user_logs` VALUES (72, 1, 2, 'view', '::1', '2025-12-31 11:30:08');
INSERT INTO `user_logs` VALUES (73, 1, 1, 'view', '::1', '2025-12-31 11:30:10');
INSERT INTO `user_logs` VALUES (74, 1, 2, 'view', '::1', '2025-12-31 11:30:10');
INSERT INTO `user_logs` VALUES (75, 1, 3, 'view', '::1', '2025-12-31 11:30:10');
INSERT INTO `user_logs` VALUES (76, 1, 4, 'view', '::1', '2025-12-31 11:30:10');
INSERT INTO `user_logs` VALUES (77, 1, 5, 'view', '::1', '2025-12-31 11:30:10');
INSERT INTO `user_logs` VALUES (78, 1, 1, 'view', '::1', '2025-12-31 11:30:24');
INSERT INTO `user_logs` VALUES (79, 1, 2, 'view', '::1', '2025-12-31 11:30:24');
INSERT INTO `user_logs` VALUES (80, 1, 3, 'view', '::1', '2025-12-31 11:30:24');
INSERT INTO `user_logs` VALUES (81, 1, 4, 'view', '::1', '2025-12-31 11:30:24');
INSERT INTO `user_logs` VALUES (82, 1, 5, 'view', '::1', '2025-12-31 11:30:24');
INSERT INTO `user_logs` VALUES (83, 1, 1, 'view', '::1', '2025-12-31 11:31:58');
INSERT INTO `user_logs` VALUES (84, 1, 2, 'view', '::1', '2025-12-31 11:31:58');
INSERT INTO `user_logs` VALUES (85, 1, 3, 'view', '::1', '2025-12-31 11:31:58');
INSERT INTO `user_logs` VALUES (86, 1, 4, 'view', '::1', '2025-12-31 11:31:58');
INSERT INTO `user_logs` VALUES (87, 1, 5, 'view', '::1', '2025-12-31 11:31:58');
INSERT INTO `user_logs` VALUES (88, 1, 1, 'view', '::1', '2025-12-31 12:35:23');
INSERT INTO `user_logs` VALUES (89, 1, 1, 'view', '::1', '2025-12-31 12:35:44');
INSERT INTO `user_logs` VALUES (90, 1, 2, 'view', '::1', '2025-12-31 12:35:44');
INSERT INTO `user_logs` VALUES (91, 1, 3, 'view', '::1', '2025-12-31 12:35:44');
INSERT INTO `user_logs` VALUES (92, 1, 4, 'view', '::1', '2025-12-31 12:35:44');
INSERT INTO `user_logs` VALUES (93, 1, 5, 'view', '::1', '2025-12-31 12:35:44');
INSERT INTO `user_logs` VALUES (94, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 13:57:49');
INSERT INTO `user_logs` VALUES (95, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 13:57:49');
INSERT INTO `user_logs` VALUES (96, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 13:57:49');
INSERT INTO `user_logs` VALUES (97, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 13:57:49');
INSERT INTO `user_logs` VALUES (98, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 13:57:49');
INSERT INTO `user_logs` VALUES (99, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (100, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (101, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (102, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (103, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (104, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:26');
INSERT INTO `user_logs` VALUES (105, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:35');
INSERT INTO `user_logs` VALUES (106, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:00:40');
INSERT INTO `user_logs` VALUES (107, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (108, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (109, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (110, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (111, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (112, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:22');
INSERT INTO `user_logs` VALUES (113, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (114, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (115, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (116, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (117, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (118, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:23');
INSERT INTO `user_logs` VALUES (119, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:25');
INSERT INTO `user_logs` VALUES (120, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:28');
INSERT INTO `user_logs` VALUES (121, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:04:47');
INSERT INTO `user_logs` VALUES (122, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:29');
INSERT INTO `user_logs` VALUES (123, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:29');
INSERT INTO `user_logs` VALUES (124, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:30');
INSERT INTO `user_logs` VALUES (125, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:30');
INSERT INTO `user_logs` VALUES (126, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (127, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (128, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (129, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (130, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (131, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:31');
INSERT INTO `user_logs` VALUES (132, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:39');
INSERT INTO `user_logs` VALUES (133, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (134, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (135, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (136, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (137, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (138, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:05:57');
INSERT INTO `user_logs` VALUES (139, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:07:41');
INSERT INTO `user_logs` VALUES (140, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:07:43');
INSERT INTO `user_logs` VALUES (141, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:07:44');
INSERT INTO `user_logs` VALUES (142, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (143, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (144, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (145, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (146, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (147, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:11');
INSERT INTO `user_logs` VALUES (148, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (149, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (150, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (151, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (152, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (153, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (154, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (155, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (156, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (157, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (158, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (159, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (160, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (161, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (162, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (163, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (164, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (165, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (166, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (167, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (168, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (169, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (170, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (171, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:14');
INSERT INTO `user_logs` VALUES (172, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (173, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (174, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (175, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (176, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (177, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:08:28');
INSERT INTO `user_logs` VALUES (178, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (179, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (180, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (181, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (182, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (183, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:22');
INSERT INTO `user_logs` VALUES (184, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:24');
INSERT INTO `user_logs` VALUES (185, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:25');
INSERT INTO `user_logs` VALUES (186, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:26');
INSERT INTO `user_logs` VALUES (187, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:26');
INSERT INTO `user_logs` VALUES (188, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:11:27');
INSERT INTO `user_logs` VALUES (189, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:21');
INSERT INTO `user_logs` VALUES (190, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:21');
INSERT INTO `user_logs` VALUES (191, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (192, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (193, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (194, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (195, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (196, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:27');
INSERT INTO `user_logs` VALUES (197, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (198, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (199, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (200, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (201, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (202, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:28');
INSERT INTO `user_logs` VALUES (203, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (204, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (205, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (206, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (207, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (208, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (209, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (210, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (211, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (212, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (213, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (214, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:29');
INSERT INTO `user_logs` VALUES (215, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (216, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (217, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (218, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (219, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (220, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:30');
INSERT INTO `user_logs` VALUES (221, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:14:31');
INSERT INTO `user_logs` VALUES (222, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:06');
INSERT INTO `user_logs` VALUES (223, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:07');
INSERT INTO `user_logs` VALUES (224, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:07');
INSERT INTO `user_logs` VALUES (225, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (226, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (227, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (228, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (229, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (230, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (231, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (232, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (233, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (234, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (235, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (236, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:09');
INSERT INTO `user_logs` VALUES (237, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (238, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (239, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (240, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (241, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (242, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (243, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (244, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (245, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (246, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (247, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (248, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (249, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (250, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (251, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (252, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (253, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (254, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (255, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (256, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (257, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (258, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (259, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (260, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (261, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (262, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (263, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (264, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (265, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (266, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (267, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (268, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (269, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:10');
INSERT INTO `user_logs` VALUES (270, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:11');
INSERT INTO `user_logs` VALUES (271, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:11');
INSERT INTO `user_logs` VALUES (272, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:11');
INSERT INTO `user_logs` VALUES (273, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (274, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (275, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (276, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (277, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (278, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (279, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (280, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (281, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (282, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (283, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (284, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (285, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (286, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (287, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (288, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (289, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (290, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (291, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (292, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (293, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (294, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (295, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (296, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:17:12');
INSERT INTO `user_logs` VALUES (297, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (298, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (299, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (300, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (301, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (302, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:19');
INSERT INTO `user_logs` VALUES (303, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:20');
INSERT INTO `user_logs` VALUES (304, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:21');
INSERT INTO `user_logs` VALUES (305, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:22');
INSERT INTO `user_logs` VALUES (306, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:22');
INSERT INTO `user_logs` VALUES (307, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:22');
INSERT INTO `user_logs` VALUES (308, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:18:22');
INSERT INTO `user_logs` VALUES (309, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (310, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (311, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (312, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (313, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (314, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (315, 1, 7, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:21:20');
INSERT INTO `user_logs` VALUES (316, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (317, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (318, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (319, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (320, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (321, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (322, 1, 7, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:41:28');
INSERT INTO `user_logs` VALUES (323, 1, 1, 'purchase', NULL, '2025-12-31 14:41:35');
INSERT INTO `user_logs` VALUES (324, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (325, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (326, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (327, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (328, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (329, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (330, 1, 7, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:26');
INSERT INTO `user_logs` VALUES (331, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:31');
INSERT INTO `user_logs` VALUES (332, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:31');
INSERT INTO `user_logs` VALUES (333, 1, 1, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (334, 1, 2, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (335, 1, 3, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (336, 1, 4, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (337, 1, 5, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (338, 1, 6, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');
INSERT INTO `user_logs` VALUES (339, 1, 7, 'view', '0:0:0:0:0:0:0:1', '2025-12-31 14:44:34');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码（加密）',
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_email`(`email` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'user1', '1822309217@qq.com', '$2y$10$9nPPflap.Zv2/S/oh1DYfOJLgTmaD3ca4FpvsKp5Pi/uwOCpeBvSe', 1, '2025-12-31 11:24:19', '2025-12-31 11:24:19');

SET FOREIGN_KEY_CHECKS = 1;
