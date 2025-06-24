module schema_party

import time

@[table: 'party_role_applications']
@[commnet: '角色应用关系表']
pub struct PartyRoleApplication {
pub:
	id          string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	role_id     string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	app_id      string @[comment: '应用ID'; omitempty; required; sql_type: 'CHAR(36)']
	permissions string @[comment: '额外权限配置'; omitempty; sql_type: 'TEXT']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
