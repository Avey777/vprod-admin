module handler

import log
import internal.structs { Context }
import internal.middleware { cores_middleware, logger_middleware,logger_middleware_generic }
import internal.logic.base { Base }
import internal.logic.admin { Admin } // 必须是路由模块内部声明的结构体
import internal.logic.admin.user { User }
import internal.logic.admin.token { Token }
import internal.logic.admin.role { Role }
import internal.logic.admin.position { Position }
import internal.logic.admin.menu { Menu }
import internal.logic.admin.department { Department }

// 封装泛型全局中间件
fn (mut app App)register_routes[T,U](mut ctrl &T, url_path string) {
  	// mut ctrl := &Base{}
  	ctrl.use(cores_middleware())
    ctrl.use(logger_middleware_generic())
  	app.register_controller[T,U](url_path, mut ctrl) or { log.error('${err}') }
   	// app.register_controller[T,Context](url_path, mut ctrl) or { log.error('${err}') }
}

pub fn (mut app App)register_handlers() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	app.use(cores_middleware())
	app.use(handler: logger_middleware)

	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &Base{}
	base_app.use(handler: logger_middleware)
	app.register_controller[Base, Context]('/base', mut base_app) or { log.error('${err}') }

	// 方式二：通过泛型的方式使用全局中间件，适合对多个控制器使用相同的中间件
	app.register_routes[Admin, Context](mut &Admin{},'/admin')
	app.register_routes[User, Context](mut &User{},'/admin/user')
	app.register_routes[Token, Context](mut &Token{},'/admin/token')
	app.register_routes[Role, Context](mut &Role{},'/admin/role')
	app.register_routes[Position, Context](mut &Position{},'/admin/position')
	app.register_routes[Menu, Context](mut &Menu{},'/admin/menu')
	app.register_routes[Department, Context](mut &Department{},'/admin/department')

}
