module handler

import log
import internal.structs { Context }
import internal.middleware
import internal.logic.base { Base }
import internal.logic.core_api.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.core_api.admin.user { User }
import internal.logic.core_api.admin.token { Token }
import internal.logic.core_api.admin.role { Role }
import internal.logic.core_api.admin.position { Position }
import internal.logic.core_api.admin.menu { Menu }
import internal.logic.core_api.admin.dictionary { Dictionary }
import internal.logic.core_api.admin.dictionarydetail { DictionaryDetail }
import internal.logic.core_api.admin.department { Department }
import internal.logic.core_api.admin.configuration { Configuration }
import internal.logic.core_api.admin.authentication { Authentication }
import internal.logic.core_api.admin.api { Api }

// 根据条件编译，选择运行的服务
pub fn (mut app App) register_handlers() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	$if fms ? {
		log.warn('register_handlers - Fms')
	}
	$if job ? {
		log.warn('register_handlers - Job')
	}
	$if mcms ? {
		log.warn('register_handlers - Mcms')
	}
	$if pay ? {
		log.warn('register_handlers - Pay')
	}
	$if sys ? {
		log.warn('register_handlers - Sys')
	} $else {
		log.warn('register_handlers - All')
		app.handler_sys_admin()
	}
}

// 封装泛型全局中间件
fn (mut app App) register_routes[T, U](mut ctrl T, url_path string) {
	// mut ctrl := &Base{}
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.authority_middleware())
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
	// app.register_controller[T,Context](url_path, mut ctrl) or { log.error('${err}') }
}

fn (mut app App) handler_sys_admin() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &Base{}
	base_app.use(handler: middleware.logger_middleware)
	app.register_controller[Base, Context]('/base', mut base_app) or { log.error('${err}') }

	//登陆 注册 忘记密码 不需要登陆认证，这里单独声明使用的中间件
	mut authentication_app := &Authentication{}
	authentication_app.use(handler: middleware.cores_middleware)
	authentication_app.use(handler: middleware.logger_middleware)
	app.register_controller[Authentication, Context]('/authentication', mut authentication_app) or {
		log.error('${err}')
	}

	// 方式二：通过泛型的方式使用全局中间件，适合对多个控制器使用相同的中间件
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

fn (mut app App) handler_tms_admin() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
}
