module job

import time

// 系统任务日志表
@[table: 'job_task_logs']
pub struct JobTaskLog {
pub:
	id             string    @[primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	started_at     time.Time @[default: now; omitempty; required; sql: 'started_at'; sql_type: 'TIMESTAMP'; zcomments: 'Task Started Time | 任务启动时间']
	finished_at    time.Time @[default: now; omitempty; required; sql: 'finished_at'; sql_type: 'TIMESTAMP'; zcomments: 'Task Finished Time | 任务完成时间']
	result         u8        @[omitempty; required; sql: 'result'; sql_type: 'tinyint unsigned'; zcomments: 'The Task Process Result | 任务执行结果']
	task_task_logs ?u64      @[omitempty; sql: 'task_task_logs'; sql_type: 'bigint unsigned'; zcomments: 'Reference to the parent task']
}
