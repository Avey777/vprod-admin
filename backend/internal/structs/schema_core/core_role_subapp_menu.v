module schema_core

@[comment: '租户角色和订阅的应用菜单关系表']
@[table: 'core_role_appmenu']
pub struct CoreRoleAppMenu {
pub:
	role_id           string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	tenant_sub_app_id string @[comment: 'tenant subscribe application id | 租户订阅的应用ID: 针对一个应用可以被多次订阅'; omitempty; required; sql_type: 'CHAR(36)']
	app_menu_id       string @[comment: 'application menu id | 应用菜单ID'; omitempty; required; sql_type: 'CHAR(36)']
}
