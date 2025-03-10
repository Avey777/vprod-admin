module handler

import log
import internal.logic.admin { Admin } // 必须是路由模块内部声明的结构体

pub fn register_routes(mut app App) {
	// register the controllers the same way as how we start a veb app
	app.register_controller[Admin, Context]('/admin', mut &Admin{}) or { log.error('${err}') }

	// app.register_controller[Member, Context]('/member', mut &Member{}) or { log.error('${err}') }
	// app.register_controller[Teant, Context]('/teant', mut &Teant{}) or { log.error('${err}') }
	// app.register_controller[Driver, Context]('/driver', mut &Driver{}) or { log.error('${err}') }
	// app.register_controller[Courier, Context]('/courier', mut &Courier{}) or { log.error('${err}') }
}
