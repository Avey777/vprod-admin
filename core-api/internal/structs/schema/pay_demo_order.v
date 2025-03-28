module schema


CREATE TABLE `pay_demo_order` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL COMMENT 'Create Time | 创建日期',
  `updated_at` timestamp NOT NULL COMMENT 'Update Time | 修改日期',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Delete Time | 删除日期',
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户编号',
  `spu_id` bigint unsigned NOT NULL COMMENT '商品编号',
  `spu_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '商品名称',
  `price` int NOT NULL COMMENT '价格，单位：分',
  `pay_status` tinyint(1) NOT NULL COMMENT '是否支付',
  `pay_order_id` bigint unsigned DEFAULT NULL COMMENT '支付订单编号',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '付款时间',
  `pay_channel_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '支付渠道',
  `pay_refund_id` bigint unsigned DEFAULT NULL COMMENT '支付退款单号',
  `refund_price` int DEFAULT NULL COMMENT '退款金额，单位：分',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '退款完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
