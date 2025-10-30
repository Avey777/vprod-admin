module routes

import log
import internal.middleware.dbpool
import internal.middleware.config
import internal.structs
import internal.logic.core_api.core_tenant.authentication
import internal.logic.core_api.core_tenant.role
import internal.logic.core_api.core_tenant.role_permission

fn (mut app AliasApp) routes_core_tenant(conn &dbpool.DatabasePool, doc_conf &config.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 必须通过token_jwt 认证
	app.register_routes_no_token[authentication.Authentication, structs.Context](mut &authentication.Authentication{},
		'/core_api/core_tenant/authentication', conn, doc_conf)
	app.register_routes_no_token[role.Role, structs.Context](mut &role.Role{}, '/core_api/core_tenant/role',
		conn, doc_conf)
	app.register_routes_no_token[role_permission.RolePermission, structs.Context](mut &role_permission.RolePermission{},
		'/core_api/core_tenant/role_permission', conn, doc_conf)
}
