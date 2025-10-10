module schema_core

@[comment: '租户角色和订阅的应用API关系表']
@[table: 'core_role_appapi']
pub struct CoreRoleAppApi {
pub:
	role_id           string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	tenant_sub_app_id string @[comment: 'tenant subscribe application id | 租户订阅的应用ID: 针对一个应用可以被多次订阅'; omitempty; required; sql_type: 'CHAR(36)']
	app_api_id        string @[comment: 'application api id | 应用Api ID'; omitempty; required; sql_type: 'CHAR(36)']
}
