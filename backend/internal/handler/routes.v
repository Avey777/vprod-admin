module handler

import log
import internal.structs { Context }
import internal.middleware
import internal.logic.db_api { Base }
import internal.middleware.dbpool

// 根据条件编译，选择运行的服务
pub fn (mut app App) register_handlers(conn &dbpool.DatabasePool) {
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
		app.handler_sys_admin()
	} $else {
		log.warn('register_handlers - All')
		app.handler_base(conn)
		app.handler_sys_admin(conn)
	}
}

// 封装泛型全局中间件
fn (mut app App) register_routes[T, U](mut ctrl T, url_path string, conn &dbpool.DatabasePool) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.authority_middleware()) // 需要token认证通过
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
	// app.register_controller[T,Context](url_path, mut ctrl) or { log.error('${err}') }
}

// 封装泛型全局中间件,无token认证
fn (mut app App) register_routes_no_token[T, U](mut ctrl T, url_path string, conn &dbpool.DatabasePool) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.db_middleware(conn))
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
	// app.register_controller[T,Context](url_path, mut ctrl) or { log.error('${err}') }
}

fn (mut app App) handler_base(conn &dbpool.DatabasePool) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &Base{}
	base_app.use(handler: middleware.cores_middleware)
	base_app.use(handler: middleware.logger_middleware)
	base_app.use(middleware.db_middleware(conn))
	app.register_controller[Base, Context]('/base', mut base_app) or { log.error('${err}') }
}
