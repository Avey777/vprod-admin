module routes

import log
import internal.structs
import internal.logic.core_api.core_tenant.authentication
import internal.logic.core_api.core_tenant.role
import internal.logic.core_api.core_tenant.role_permission

fn (mut app AliasApp) routes_core_tenant(mut ctx structs.Context) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 必须通过token_jwt 认证
	app.register_routes_no_token[authentication.Authentication, structs.Context](mut &authentication.Authentication{},
		'/core_tenant/authentication', mut ctx)
	app.register_routes_no_token[role.Role, structs.Context](mut &role.Role{}, '/core_tenant/role', mut
		ctx)
	app.register_routes_no_token[role_permission.RolePermission, structs.Context](mut &role_permission.RolePermission{},
		'/core_tenant/role_permission', mut ctx)
}
