module schema_sys

@[comment: '用户角色关联表(一个用户可以拥有多个角色)']
@[table: 'sys_user_roles']
pub struct SysUserRole {
pub:
	user_id string @[comment: '用户ID'; sql_type: 'CHAR(36)']
	role_id string @[comment: '角色ID'; sql_type: 'CHAR(36)']
}
