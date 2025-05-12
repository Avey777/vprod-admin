module schema

import time

// Token表
@[table: 'core_tokens']
pub struct CoreToken {
pub:
	id         string    @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomment: ' UUID']
	user_id    string    @[omitempty; sql: 'user_id'; sql_type: 'CHAR(36)'; zcomment: ' User`s UUID | 用户的UUID']
	username   string    @[default: '"unknown"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Username | 用户名']
	token      string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Token string | Token 字符串']
	source     string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Log in source such as GitHub | Token 来源 （本地为core, 第三方如github等）']
	expired_at time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomment: ' Expire time | 过期时间']
	status     u8        @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
