module schema_party

import time

@[comment: '团队应用关系表（用于应用共享）']
@[table: 'party_team_applications']
pub struct PartyTeamApplication {
pub:
	id             string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	owner_team_id  string @[comment: '应用所有者团队ID'; omitempty; required; sql_type: 'CHAR(36)']
	shared_team_id string @[comment: '被共享团队ID'; omitempty; required; sql_type: 'CHAR(36)']
	application_id string @[comment: '应用ID'; omitempty; required; sql_type: 'CHAR(36)']
	access_level   u8     @[comment: '访问权限级别：0-只读，1-读写，2-管理员'; default: 1; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
