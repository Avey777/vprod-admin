module handler

import log
import internal.middleware.dbpool
import internal.middleware.conf
import internal.structs { Context }
// import internal.middleware
import internal.logic.sys_api.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.sys_api.admin.user { User }
import internal.logic.sys_api.admin.token { Token }
import internal.logic.sys_api.admin.role { Role }
import internal.logic.sys_api.admin.position { Position }
import internal.logic.sys_api.admin.menu { Menu }
import internal.logic.sys_api.admin.mfa { MFA }
import internal.logic.sys_api.admin.dictionary { Dictionary }
import internal.logic.sys_api.admin.dictionarydetail { DictionaryDetail }
import internal.logic.sys_api.admin.department { Department }
import internal.logic.sys_api.admin.configuration { Configuration }
import internal.logic.sys_api.admin.authentication { Authentication }
import internal.logic.sys_api.admin.api { Api }

fn (mut app App) handler_sys_admin(conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式二：通过泛型的方式使用全局中间件，适合对多个控制器使用相同的中间件

	//不需要token_jwt 认证
	app.register_routes_no_token[Authentication, Context](mut &Authentication{}, '/authentication',
		conn, doc_conf)
	app.register_routes_no_token[MFA, Context](mut &MFA{}, '/mfa', conn, doc_conf)

	// 必须通过token_jwt 认证
	app.register_routes[Admin, Context](mut &Admin{}, '/admin', conn, doc_conf)
	app.register_routes[User, Context](mut &User{}, '/admin/user', conn, doc_conf)
	app.register_routes[Token, Context](mut &Token{}, '/admin/token', conn, doc_conf)
	app.register_routes[Role, Context](mut &Role{}, '/admin/role', conn, doc_conf)
	app.register_routes[Position, Context](mut &Position{}, '/admin/position', conn, doc_conf)
	app.register_routes[Menu, Context](mut &Menu{}, '/admin/menu', conn, doc_conf)
	app.register_routes[Dictionary, Context](mut &Dictionary{}, '/admin/dictionary', conn,
		doc_conf)
	app.register_routes[DictionaryDetail, Context](mut &DictionaryDetail{}, '/admin/dictionarydetail',
		conn, doc_conf)
	app.register_routes[Department, Context](mut &Department{}, '/admin/department', conn,
		doc_conf)
	app.register_routes[Configuration, Context](mut &Configuration{}, '/admin/configuration',
		conn, doc_conf)
	app.register_routes[Api, Context](mut &Api{}, '/admin/api', conn, doc_conf)
}
