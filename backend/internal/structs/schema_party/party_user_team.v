module schema_party

import time

@[comment: '团队用户关系表']
@[table: 'party_team_users']
pub struct PartyTeamUser {
pub:
	id      string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	user_id string @[comment: '用户ID'; omitempty; required; sql_type: 'CHAR(36)']
	team_id string @[comment: '团队ID'; omitempty; required; sql_type: 'CHAR(36)']
	role    u8     @[comment: '角色，0：成员，1：管理员，2：所有者'; default: 0; omitempty; sql_type: 'tinyint']

	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
