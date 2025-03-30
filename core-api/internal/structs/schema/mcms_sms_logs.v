module schema

import time

// 短信发送日志表
@[table: 'mcms_sms_logs']
pub struct McmsSmsLog {
pub:
	id           string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	phone_number string @[omitempty; required; sql: 'phone_number'; sql_type: 'VARCHAR(255)'; zcomments: 'The target phone number | 目标电话']
	content      string @[omitempty; required; sql: 'content'; sql_type: 'VARCHAR(255)'; zcomments: 'The content | 发送的内容']
	send_status  u8     @[omitempty; required; sql: 'send_status'; sql_type: 'tinyint unsigned'; zcomments: 'The send status, 0 unknown 1 success 2 failed | 发送的状态, 0 未知， 1 成功， 2 失败']
	provider     string @[omitempty; required; sql: 'provider'; sql_type: 'VARCHAR(255)'; zcomments: 'The sms service provider | 短信服务提供商']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
