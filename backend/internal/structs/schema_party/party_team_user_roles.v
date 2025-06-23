module schema_party

import time

@[commnet: '团队用户角色关系表']
@[table: 'party_user_roles']
pub struct PartyUserRole {
pub:
	id      string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	team_id string @[comment: '团队ID'; omitempty; required; sql_type: 'CHAR(36)']
	user_id string @[comment: '用户ID'; omitempty; required; sql_type: 'CHAR(36)']
	role_id string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	// app_id      string    @[omitempty; required; sql_type: 'CHAR(36)'; comment: '应用ID']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
