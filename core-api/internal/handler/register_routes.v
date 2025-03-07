module handler

import log
import internal.logic { Admin }  // 必须是路由模块内部声明的结构体

pub fn register_routes(mut app App) {
	// register the controllers the same way as how we start a veb app
	// mut admin_app := &Admin{}
	// app.register_controller[Admin, Context]('/admin', mut admin_app) or {panic(err)}

	app.register_controller[Admin, Context]('/admin', mut &Admin{}) or { log.error('${err}') }
}
