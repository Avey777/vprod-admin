module schema_sys

@[comment: '角色菜单关联表(一个角色可以拥有多个菜单)']
@[table: 'sys_role_menus']
pub struct SysRoleMenu {
pub:
	role_id string @[comment: '角色ID'; primary; sql_type: 'CHAR(36)']
	menu_id string @[comment: '菜单ID'; primary; sql_type: 'CHAR(36)']
}
