module schema_party

import time

// 团队表
@[table: 'party_teams']
pub struct PartyTeam {
pub:
	id          string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '团队ID']
	name        string  @[omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name'; zcomments: '团队名称']
	description ?string @[omitempty; sql_type: 'VARCHAR(512)'; zcomments: '团队描述']
	logo        ?string @[omitempty; sql_type: 'VARCHAR(512)'; zcomments: '团队Logo']
	status      u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
