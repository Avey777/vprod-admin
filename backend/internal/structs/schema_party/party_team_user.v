module schema_party

import time

// 团队用户关系表
@[table: 'party_team_users']
pub struct PartyTeamUser {
pub:
	id      string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '关系ID']
	user_id string @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '用户ID']
	team_id string @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '团队ID']
	role    u8     @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '角色，0：成员，1：管理员，2：所有者']

	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}

