module handler

import log
import internal.structs { Context }
// import internal.middleware
import internal.logic.core_api.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.core_api.admin.user { User }
import internal.logic.core_api.admin.token { Token }
import internal.logic.core_api.admin.role { Role }
import internal.logic.core_api.admin.position { Position }
import internal.logic.core_api.admin.menu { Menu }
import internal.logic.core_api.admin.mfa { MFA }
import internal.logic.core_api.admin.dictionary { Dictionary }
import internal.logic.core_api.admin.dictionarydetail { DictionaryDetail }
import internal.logic.core_api.admin.department { Department }
import internal.logic.core_api.admin.configuration { Configuration }
import internal.logic.core_api.admin.authentication { Authentication }
import internal.logic.core_api.admin.api { Api }

fn (mut app App) handler_sys_admin() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式二：通过泛型的方式使用全局中间件，适合对多个控制器使用相同的中间件

	//不需要token_jwt 认证
	app.register_routes_no_token[Authentication, Context](mut &Authentication{}, '/authentication')
	app.register_routes_no_token[MFA, Context](mut &MFA{}, '/mfa')

	// 必须通过token_jwt 认证
	app.register_routes[Admin, Context](mut &Admin{}, '/admin')
	app.register_routes[User, Context](mut &User{}, '/admin/user')
	app.register_routes[Token, Context](mut &Token{}, '/admin/token')
	app.register_routes[Role, Context](mut &Role{}, '/admin/role')
	app.register_routes[Position, Context](mut &Position{}, '/admin/position')
	app.register_routes[Menu, Context](mut &Menu{}, '/admin/menu')
	app.register_routes[Dictionary, Context](mut &Dictionary{}, '/admin/dictionary')
	app.register_routes[DictionaryDetail, Context](mut &DictionaryDetail{}, '/admin/dictionarydetail')
	app.register_routes[Department, Context](mut &Department{}, '/admin/department')
	app.register_routes[Configuration, Context](mut &Configuration{}, '/admin/configuration')
	app.register_routes[Api, Context](mut &Api{}, '/admin/api')
}
