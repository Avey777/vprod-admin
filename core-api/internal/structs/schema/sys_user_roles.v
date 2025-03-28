module schema

// 用户角色关联表(一个用户可以拥有多个角色)
@[table: 'sys_user_roles']
pub struct SysUserRole {
pub:
	user_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '用户ID']
	role_id string @[primary; sql_type: 'CHAR(36)'; zcomments: '角色ID']
}
