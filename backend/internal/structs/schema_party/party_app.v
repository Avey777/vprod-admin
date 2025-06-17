module schema_party

import time

// 应用表
@[table: 'party_applications']
pub struct PartyApplication {
pub:
	id          string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '应用ID']
	name        string  @[omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name'; zcomments: '应用名称']
	app_key     string  @[omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'app_key'; zcomments: '应用Key']
	app_secret  string  @[omitempty; required; sql_type: 'VARCHAR(255)'; zcomments: '应用Secret']
	description ?string @[omitempty; sql_type: 'VARCHAR(512)'; zcomments: '应用描述']
	icon        ?string @[omitempty; sql_type: 'VARCHAR(512)'; zcomments: '应用图标']
	status      u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']
	team_id     string  @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '所属团队ID']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
