module handler

import log
import internal.structs { Context }
import internal.middleware { cores_middleware, logger_middleware }
import internal.logic.base { Base }
import internal.logic.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.admin.user { User }


pub fn register_handlers(mut app App) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	app.use(cores_middleware())
	app.use(handler: logger_middleware)

	mut base_app := &Base{}
	base_app.use(handler: logger_middleware)
	app.register_controller[Base, Context]('/base', mut base_app) or { log.error('${err}') }

	mut admin_app := &Admin{}
	admin_app.use(cores_middleware())
	admin_app.use(handler: logger_middleware)
	app.register_controller[Admin, Context]('/admin', mut admin_app) or { log.error('${err}') }

	mut admin_user_app := &user.User{}
	admin_user_app.use(cores_middleware())
	admin_user_app.use(handler: logger_middleware)
	app.register_controller[User, Context]('/admin/user', mut admin_user_app) or { log.error('${err}') }

	// app.register_controller[Member, Context]('/member', mut &Member{}) or { log.error('${err}') }
	// app.register_controller[Teant, Context]('/teant', mut &Teant{}) or { log.error('${err}') }
	// app.register_controller[Driver, Context]('/driver', mut &Driver{}) or { log.error('${err}') }
	// app.register_controller[Courier, Context]('/courier', mut &Courier{}) or { log.error('${err}') }
}
