module schema_party

import time

// 菜单表
@[table: 'party_menus']
pub struct PartyMenu {
pub:
	id        string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '菜单ID']
	name      string  @[omitempty; required; sql_type: 'VARCHAR(255)'; zcomments: '菜单名称']
	path      string  @[omitempty; required; sql_type: 'VARCHAR(255)'; zcomments: '菜单路径']
	component string  @[omitempty; required; sql_type: 'VARCHAR(255)'; zcomments: '组件路径']
	icon      ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomments: '菜单图标']
	title     string  @[omitempty; required; sql_type: 'VARCHAR(255)'; zcomments: '菜单标题']
	sort      u32     @[default: 0; omitempty; sql_type: 'int'; zcomments: '排序']
	parent_id string  @[default: '0'; omitempty; sql_type: 'CHAR(36)'; zcomments: '父菜单ID']
	hidden    u8      @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '是否隐藏']
	status    u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']
	app_id    string  @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '所属应用ID']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
