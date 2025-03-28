module schema

// import time

// // 任务日志表
// @[table: 'task_logs']
// pub struct TaskLog {
// pub:
// 	id                          u64              @[comment: "ID"]
// 	started_at                  time.Time        @[immutable; default: ''; comment: "Task Started Time | 任务启动时间"]
// 	finished_at                 ?time.Time       @[comment: "Task Finished Time | 任务完成时间"]
// 	result                      u8               @[comment: "The Task Process Result | 任务执行结果"]
// }



CREATE TABLE `sys_task_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `started_at` timestamp NOT NULL COMMENT 'Task Started Time | 任务启动时间',
  `finished_at` timestamp NOT NULL COMMENT 'Task Finished Time | 任务完成时间',
  `result` tinyint unsigned NOT NULL COMMENT 'The Task Process Result | 任务执行结果',
  `task_task_logs` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
