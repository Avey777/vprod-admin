module routes

import log
import internal.structs { Context }
import internal.middleware
import internal.logic.db_api { Base }
import internal.middleware.dbpool
import internal.middleware.conf

// 根据条件编译，选择运行的服务
pub fn (mut app AliasApp) routes_ifdef(conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	$if fms ? {
		log.warn('routes_ifdef - Fms')
	}
	$if core ? {
		log.warn('routes_ifdef - Core')
		app.routes_core_admin(conn, doc_conf)
	}
	$if job ? {
		log.warn('routes_ifdef - Job')
	}
	$if mcms ? {
		log.warn('routes_ifdef - Mcms')
	}
	$if pay ? {
		log.warn('routes_ifdef - Pay')
	}
	$if sys ? {
		log.warn('routes_ifdef - Sys')
		app.routes_sys_admin()
	} $else {
		log.warn('routes_ifdef - All')
		app.routes_base(conn, doc_conf)
		app.routes_sys_admin(conn, doc_conf)
		app.routes_core_admin(conn, doc_conf)
	}
}

// 封装泛型sys全局中间件
fn (mut app AliasApp) register_routes_sys[T, U](mut ctrl T, url_path string, conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.config_middle(doc_conf))
	ctrl.use(middleware.db_middleware(conn))
	ctrl.use(middleware.authority_middleware()) // sys鉴权使用,需要token认证通过,需要在db_middleware之后
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}

// 封装泛型core全局中间件
fn (mut app AliasApp) register_routes_core[T, U](mut ctrl T, url_path string, conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.config_middle(doc_conf))
	ctrl.use(middleware.db_middleware(conn))
	ctrl.use(middleware.authority_middleware_core()) // Tenant租户鉴权专用,需要token认证通过,需要在db_middleware之后
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}

// 封装泛型全局中间件,无token认证
fn (mut app AliasApp) register_routes_no_token[T, U](mut ctrl T, url_path string, conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.config_middle(doc_conf))
	ctrl.use(middleware.db_middleware(conn))
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}

fn (mut app AliasApp) routes_base(conn &dbpool.DatabasePool, doc_conf &conf.GlobalConfig) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &Base{}
	base_app.use(handler: middleware.cores_middleware)
	base_app.use(handler: middleware.logger_middleware)
	base_app.use(middleware.db_middleware(conn))
	base_app.use(middleware.config_middle(doc_conf))
	app.register_controller[Base, Context]('/base', mut base_app) or { log.error('${err}') }
}
