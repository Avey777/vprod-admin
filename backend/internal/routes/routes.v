module routes

import log
import veb
import internal.structs { Context }
import internal.middleware

// 通用中间件设置函数 - 减少代码重复
fn (mut app AliasApp) common_middleware[T, U](mut ctrl T, mut ctx Context) {
	ctrl.use(middleware.cores_middleware_generic())
	ctrl.use(middleware.logger_middleware_generic())
	ctrl.use(middleware.config_middle(ctx.config))
	ctrl.use(middleware.db_middleware(ctx.dbpool))
	ctrl.use(middleware.i18n_middleware(ctx.i18n))
	ctrl.use(veb.encode_gzip[Context]())
}

// 封装泛型sys全局中间件
fn (mut app AliasApp) register_routes_sys[T, U](mut ctrl T, url_path string, mut ctx Context) {
	app.common_middleware[T, U](mut ctrl, mut ctx)
	// ctrl.use(middleware.authority_middleware()) // sys鉴权使用,需要token认证通过,需要在db_middleware之后
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}

// 封装泛型core全局中间件
fn (mut app AliasApp) register_routes_core[T, U](mut ctrl T, url_path string, mut ctx Context) {
	app.common_middleware[T, U](mut ctrl, mut ctx)
	ctrl.use(middleware.authority_middleware_core()) // Tenant租户鉴权专用,需要token认证通过,需要在db_middleware之后
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}

// 封装泛型全局中间件,无token认证
fn (mut app AliasApp) register_routes_no_token[T, U](mut ctrl T, url_path string, mut ctx Context) {
	app.common_middleware[T, U](mut ctrl, mut ctx)
	app.register_controller[T, U](url_path, mut ctrl) or { log.error('${err}') }
}
