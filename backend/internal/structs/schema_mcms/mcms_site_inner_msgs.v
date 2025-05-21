module schema_mcms

import time

// 站内私信消息表
@[table: 'mcms_site_inner_msgs']
pub struct McmsSiteInnerMsg {
pub:
	id                            string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	avatar                        ?string @[omitempty; sql: 'avatar'; sql_type: 'VARCHAR(255)'; zcomments: 'Avatar | 头像或图标']
	title                         string  @[omitempty; required; sql: 'title'; sql_type: 'VARCHAR(255)'; zcomments: 'Message Title | 消息标题']
	content                       string  @[omitempty; required; sql: 'content'; sql_type: 'VARCHAR(255)'; zcomments: 'Message Content | 消息内容']
	sender                        string  @[immutable; omitempty; sql: 'sender'; sql_type: 'CHAR(36)'; zcomments: 'Message Sender | 消息发送者']
	receiver                      string  @[immutable; omitempty; sql: 'receiver'; sql_type: 'CHAR(36)'; zcomments: 'Message Receiver | 消息接收者']
	is_read                       u8      @[omitempty; required; sql: 'is_read'; sql_type: 'tinyint(1)'; zcomments: 'Read symbol | 已读状态']
	inner_msg_category_inner_msgs ?u64    @[omitempty; sql: 'inner_msg_category_inner_msgs'; sql_type: 'bigint unsigned'; zcomments: 'Message category reference']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
