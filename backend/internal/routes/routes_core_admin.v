module routes

import log
import internal.structs
import internal.logic.core_api.core_admin.api
import internal.logic.core_api.core_admin.menu
import internal.logic.core_api.core_admin.oauthprovider
import internal.logic.core_api.core_admin.user

fn (mut app AliasApp) routes_core_admin(mut ctx structs.Context) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 必须通过token_jwt 认证
	app.register_routes_no_token[api.Api, structs.Context](mut &api.Api{}, '/core_admin/api', mut
		ctx)
	app.register_routes_no_token[menu.Menu, structs.Context](mut &menu.Menu{}, '/core_admin/menu', mut
		ctx)
	app.register_routes_no_token[oauthprovider.OauthProvider, structs.Context](mut &oauthprovider.OauthProvider{},
		'/core_admin/oauthprovider', mut ctx)
	app.register_routes_no_token[user.User, structs.Context](mut &user.User{}, '/core_admin/user', mut
		ctx)
}
