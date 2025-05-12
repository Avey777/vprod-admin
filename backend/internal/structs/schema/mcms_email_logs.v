module schema

import time

// 邮件发送日志表
@[table: 'mcms_email_logs']
pub struct McmsEmailLog {
pub:
	id          string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	target      string @[omitempty; required; sql: 'target'; sql_type: 'VARCHAR(255)'; zcomments: 'The target email address | 目标邮箱地址']
	subject     string @[omitempty; required; sql: 'subject'; sql_type: 'VARCHAR(255)'; zcomments: 'The subject | 发送的标题']
	content     string @[omitempty; required; sql: 'content'; sql_type: 'VARCHAR(255)'; zcomments: 'The content | 发送的内容']
	send_status u8     @[omitempty; required; sql: 'send_status'; sql_type: 'tinyint unsigned'; zcomments: 'The send status, 0 unknown 1 success 2 failed | 发送的状态, 0 未知， 1 成功， 2 失败']
	provider    string @[omitempty; required; sql: 'provider'; sql_type: 'VARCHAR(255)'; zcomments: 'The email service provider | 邮件服务提供商']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
