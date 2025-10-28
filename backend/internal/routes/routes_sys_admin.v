module routes

import log
import internal.middleware.dbpool
import internal.middleware.conf
import internal.structs { Context }
// import internal.middleware
import internal.logic.sys_api.sys_admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.sys_api.sys_admin.user { User }
import internal.logic.sys_api.sys_admin.token { Token }
import internal.logic.sys_api.sys_admin.role { Role }
import internal.logic.sys_api.sys_admin.role_permission { RolePermission }
import internal.logic.sys_api.sys_admin.position { Position }
import internal.logic.sys_api.sys_admin.menu { Menu }
import internal.logic.sys_api.sys_admin.mfa { MFA }
import internal.logic.sys_api.sys_admin.dictionary { Dictionary }
import internal.logic.sys_api.sys_admin.dictionarydetail { DictionaryDetail }
import internal.logic.sys_api.sys_admin.department { Department }
import internal.logic.sys_api.sys_admin.configuration { Configuration }
import internal.logic.sys_api.sys_admin.authentication { Authentication }
import internal.logic.sys_api.sys_admin.api { Api }

fn (mut app AliasApp) routes_sys_admin(conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式二：通过泛型的方式使用全局中间件，适合对多个控制器使用相同的中间件

	//不需要token_jwt 认证
	app.register_routes_no_token[Authentication, Context](mut &Authentication{}, '/sys_api/admin/authentication',
		conn, doc_conf)
	app.register_routes_no_token[MFA, Context](mut &MFA{}, '/sys_api/admin/mfa', conn,
		doc_conf)

	// 必须通过token_jwt 认证
	app.register_routes_sys[Admin, Context](mut &Admin{}, '/sys_api/admin', conn, doc_conf)
	app.register_routes_sys[User, Context](mut &User{}, '/sys_api/admin/user', conn, doc_conf)
	app.register_routes_sys[Token, Context](mut &Token{}, '/sys_api/admin/token', conn,
		doc_conf)
	app.register_routes_sys[Role, Context](mut &Role{}, '/sys_api/admin/role', conn, doc_conf)
	app.register_routes_sys[RolePermission, Context](mut &RolePermission{}, '/sys_api/admin/role_permission',
		conn, doc_conf)
	app.register_routes_sys[Position, Context](mut &Position{}, '/sys_api/admin/position',
		conn, doc_conf)
	app.register_routes_sys[Menu, Context](mut &Menu{}, '/sys_api/admin/menu', conn, doc_conf)
	app.register_routes_sys[Dictionary, Context](mut &Dictionary{}, '/sys_api/admin/dictionary',
		conn, doc_conf)
	app.register_routes_sys[DictionaryDetail, Context](mut &DictionaryDetail{}, '/sys_api/admin/dictionarydetail',
		conn, doc_conf)
	app.register_routes_sys[Department, Context](mut &Department{}, '/sys_api/admin/department',
		conn, doc_conf)
	app.register_routes_sys[Configuration, Context](mut &Configuration{}, '/sys_api/admin/configuration',
		conn, doc_conf)
	app.register_routes_sys[Api, Context](mut &Api{}, '/sys_api/admin/api', conn, doc_conf)
}
