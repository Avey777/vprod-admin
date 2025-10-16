module schema_core

@[unique_key: 'role_id, api_id, source_type, source_id']
@[comment: '租户角色与api资源关系表']
@[table: 'core_tenant_role_resource_api']
pub struct CoreTenantRoleResourceApi {
pub:
	role_id string @[comment: '角色ID'; sql_type: 'CHAR(36)']
	// 资源级别,指向某个具体的资源实体（如某个 API、菜单项、按钮等）的唯一 ID
	api_id string @[comment: 'API ID'; sql_type: 'CHAR(36)']
	// 来源级别,表示这个资源属于哪个来源（例如哪个租户、哪个订阅的子应用、哪个全局模块）
	source_type string @[comment: '来源类型: tenant/app'; sql_type: 'VARCHAR(32)']
	source_id   string @[comment: '来源ID: app_id或tenant_id等'; sql_type: 'CHAR(36)']
}

// resource_type string @[comment: '资源类型: api/menu/button'; sql_type: 'VARCHAR(32)']
