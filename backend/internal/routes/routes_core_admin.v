module routes

import log
import internal.middleware.dbpool
import internal.middleware.conf
import internal.structs
// import internal.middleware
import internal.logic.core_api.core_admin.api

fn (mut app AliasApp) routes_core_admin(conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 必须通过token_jwt 认证
	app.register_routes_no_token[api.Api, structs.Context](mut &api.Api{}, '/core_api/admin/api',
		conn, doc_conf)
}
