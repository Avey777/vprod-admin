module schema

// import time
// import rand

// // 任务表
// @[table: 'tasks']
// pub struct Task {
// pub:
//   id                          uuid        @[immutable; default: ''] // UUID

// 	name                        string           @[comment: "Task Name | 任务名称"]
// 	task_group                  string           @[comment: "Task Group | 任务分组"]
// 	cron_expression             string           @[comment: "Cron expression | 定时任务表达式"]
// 	pattern                     string           @[comment: "Cron Pattern | 任务的模式 （用于区分和确定要执行的任务）"]
// 	payload                     string           @[comment: "The data used in cron (JSON string) | 任务需要的数据(JSON 字符串)"]
// }



CREATE TABLE `sys_tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL COMMENT 'Create Time | 创建日期',
  `updated_at` timestamp NOT NULL COMMENT 'Update Time | 修改日期',
  `status` tinyint unsigned DEFAULT '1' COMMENT 'Status 1: normal 2: ban | 状态 1 正常 2 禁用',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Task Name | 任务名称',
  `task_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Task Group | 任务分组',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Cron expression | 定时任务表达式',
  `pattern` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Cron Pattern | 任务的模式 （用于区分和确定要执行的任务）',
  `payload` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'The data used in cron (JSON string) | 任务需要的数据(JSON 字符串)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_pattern` (`pattern`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
