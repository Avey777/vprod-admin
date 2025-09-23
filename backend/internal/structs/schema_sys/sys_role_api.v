module schema_sys

@[comment: '角色菜单关联表(一个角色可以拥有多个菜单)']
@[table: 'sys_role_api']
pub struct SysRoleApi {
pub:
	role_id string @[comment: '角色ID'; primary; sql_type: 'CHAR(36)']
	api_id  string @[comment: 'API ID'; primary; sql_type: 'CHAR(36)']
}
