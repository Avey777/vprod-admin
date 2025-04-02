module handler

import log
import admin
import structs {Context}

pub fn register_routes(mut app App) {
	app.use(handler: before_request)
	mut admin_app := &admin.Admin{}

	admin_app.use(handler: before_request)

	app.register_controller[admin.Admin, Context]('/admin', mut admin_app) or {
		log.error('${err}')
	}
}

pub fn before_request(mut ctx Context) bool {
	// $if trace_before_request ? {
	log.info('[veb] before_request: ${ctx.req.method} ${ctx.req.url}')
	// }
	return true
}
