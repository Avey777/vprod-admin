module schema_party

import time

// 角色菜单关系表
@[table: 'party_role_menus']
pub struct PartyRoleMenu {
pub:
	id      string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '关系ID']
	role_id string @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '角色ID']
	menu_id string @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '菜单ID']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
