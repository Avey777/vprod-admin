module schema_sys

import time

@[comment: '菜单表']
@[table: 'sys_menus']
pub struct SysMenu {
pub:
	id                    string  @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	parent_id             ?string @[comment: ' Parent menu ID | 父菜单ID'; immutable; primary; sql: 'parent_id'; sql_type: 'CHAR(36)']
	menu_level            u64     @[omitempty; sql_type: 'int'; zcomment: 'Menu level | 菜单层级']
	menu_type             u64     @[omitempty; sql_type: 'int'; zcomment: 'Menu type | 菜单类型 （菜单或目录）0 目录 1 菜单']
	path                  ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: ' Index path | 菜单路由路径']
	name                  string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Index name | 菜单名称']
	redirect              ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: ' Redirect path | 跳转路径 （外链）']
	component             ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The path of vue file | 组件路径']
	disabled              ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Disable status | 是否停用']
	service_name          ?string @[default: '"Other"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Service Name | 服务名称'] //
	permission            ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Permission symbol | 权限标识']
	title                 string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Menu name | 菜单显示标题']
	icon                  string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Menu icon | 菜单图标']
	hide_menu             ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: ' Hide menu | 是否隐藏菜单']
	hide_breadcrumb       ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Hide the breadcrumb | 隐藏面包屑']
	ignore_keep_alive     ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Do not keep alive the tab | 取消页面缓存']
	hide_tab              ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: ' Hide the tab header | 隐藏页头']
	frame_src             ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Show iframe | 内嵌 iframe']
	carry_param           ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'The route carries parameters or not | 携带参数']
	hide_children_in_menu ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Hide children menu or not | 隐藏所有子菜单']
	affix                 ?u8     @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Affix tab | Tab 固定']
	dynamic_level         ?u32    @[default: 20; omitempty; sql_type: 'int'; zcomment: 'The maximum number of pages the router can open | 能打开的子TAB数']
	real_path             ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The real path of the route without dynamic part | 菜单路由不包含参数部分']
	sort                  u32     @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
