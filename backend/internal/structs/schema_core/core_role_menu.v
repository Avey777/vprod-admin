module schema_core

@[unique_key: 'role_id, menu_id, source_type, source_id']
@[comment: '租户角色与菜单资源关系表']
@[table: 'core_role_menu']
pub struct CoreRoleMenu {
pub:
	role_id string @[comment: '角色ID'; sql_type: 'CHAR(36)']
	menu_id string @[comment: '菜单 ID'; sql_type: 'CHAR(36)']
	// 来源级别,表示这个资源属于哪个来源（例如哪个租户、哪个订阅的子应用、哪个全局模块）
	source_type string @[comment: '来源类型: tenant/app'; sql_type: 'VARCHAR(32)']
	source_id   string @[comment: '来源ID: app_id或tenant_id等'; sql_type: 'CHAR(36)']
}
