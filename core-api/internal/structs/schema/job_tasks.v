module schema

import time

// 系统定时任务表
@[table: 'sys_tasks']
pub struct SysTask {
pub:
	id              string @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name            string @[omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; zcomments: 'Task Name | 任务名称']
	task_group      string @[omitempty; required; sql: 'task_group'; sql_type: 'VARCHAR(255)'; zcomments: 'Task Group | 任务分组']
	cron_expression string @[omitempty; required; sql: 'cron_expression'; sql_type: 'VARCHAR(255)'; zcomments: 'Cron expression | 定时任务表达式']
	pattern         string @[omitempty; required; sql: 'pattern'; sql_type: 'VARCHAR(255)'; unique: 'task_pattern'; zcomments: 'Cron Pattern | 任务的模式 （用于区分和确定要执行的任务）']
	payload         string @[omitempty; required; sql: 'payload'; sql_type: 'VARCHAR(255)'; zcomments: 'The data used in cron (JSON string) | 任务需要的数据(JSON 字符串)']
	status          u8     @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
