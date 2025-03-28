module schema

// 用户角色关联表(一个用户可以拥有多个角色)
@[table: 'sys_role_menus']
pub struct SysRoleMenu {
pub:
	role_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '角色ID']
	menu_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '菜单ID']
}
