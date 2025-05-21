module schema_sys

// 角色菜单关联表(一个角色可以拥有多个菜单)
@[table: 'sys_role_menus']
pub struct SysRoleMenu {
pub:
	role_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '角色ID']
	menu_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '菜单ID']
}
