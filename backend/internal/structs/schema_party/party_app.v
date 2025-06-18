module schema_party

import time

@[table: 'party_applications']
@[comment: '应用表']
pub struct PartyApplication {
pub:
	id          string  @[comment: '应用ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name        string  @[comment: '应用名称'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name']
	app_key     string  @[comment: '应用Key'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'app_key']
	app_secret  string  @[comment: '应用Secret'; omitempty; required; sql_type: 'VARCHAR(255)']
	description ?string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(512)']
	icon        ?string @[comment: '应用图标'; omitempty; sql_type: 'VARCHAR(512)']
	status      u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
	team_id     string  @[comment: '所属团队ID'; omitempty; required; sql_type: 'CHAR(36)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
