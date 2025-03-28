module handler

import log
import internal.logic.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.base { Base }

pub fn register_routes(mut app App) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	app.use(handler: logger_middleware)
	// register the controllers the same way as how we start a veb app
	app.register_controller[Base, Context]('/base', mut &Base{}) or { log.error('${err}') }
	app.register_controller[Admin, Context]('/admin', mut &Admin{}) or { log.error('${err}') }

	// app.register_controller[Member, Context]('/member', mut &Member{}) or { log.error('${err}') }
	// app.register_controller[Teant, Context]('/teant', mut &Teant{}) or { log.error('${err}') }
	// app.register_controller[Driver, Context]('/driver', mut &Driver{}) or { log.error('${err}') }
	// app.register_controller[Courier, Context]('/courier', mut &Courier{}) or { log.error('${err}') }
}

//日志中间件（未知原因：对 register_controller 的路由不生效）
pub fn logger_middleware(mut ctx Context) bool {
	// $if trace_before_request ? {
	log.info('[veb] trace_before_request: ${ctx.req.method} ${ctx.req.url}')
	// }
	return true
}
