module schema_core

import time

@[comment: '应用菜单表']
@[table: 'core_team_menus']
pub struct CoreTeamMenu {
pub:
	id        string  @[comment: '菜单ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name      string  @[comment: '菜单名称'; omitempty; required; sql_type: 'VARCHAR(255)']
	path      string  @[comment: '菜单路径'; omitempty; required; sql_type: 'VARCHAR(255)']
	component string  @[comment: '组件路径'; omitempty; required; sql_type: 'VARCHAR(255)']
	icon      ?string @[comment: '菜单图标'; omitempty; sql_type: 'VARCHAR(255)']
	title     string  @[comment: '菜单标题'; omitempty; required; sql_type: 'VARCHAR(255)']
	sort      u32     @[comment: '排序'; default: 0; omitempty; sql_type: 'int']
	parent_id string  @[comment: '父菜单ID'; default: '0'; omitempty; sql_type: 'CHAR(36)']
	hidden    u8      @[comment: '是否隐藏'; default: 0; omitempty; sql_type: 'tinyint(1)']
	status    u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
	app_id    string  @[comment: '所属应用ID'; omitempty; required; sql_type: 'CHAR(36)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
