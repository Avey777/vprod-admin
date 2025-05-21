module schema_mcms

import time

// 站内消息通知表
@[table: 'mcms_site_notifications']
pub struct McmsSiteNotification {
pub:
	id      string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	avatar  ?string @[omitempty; sql: 'avatar'; sql_type: 'VARCHAR(255)'; zcomments: 'Avatar | 头像或图标']
	title   string  @[omitempty; required; sql: 'title'; sql_type: 'VARCHAR(255)'; zcomments: 'Notification Title | 公告标题']
	content string  @[omitempty; required; sql: 'content'; sql_type: 'VARCHAR(255)'; zcomments: 'Notification Content | 公告内容']
	creator string  @[immutable; omitempty; sql: 'creator'; sql_type: 'CHAR(36)'; zcomments: 'Creator | 创建者']
	status  u8      @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint(1)'; zcomments: 'State true: normal false: ban | 状态 true 正常 false 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
