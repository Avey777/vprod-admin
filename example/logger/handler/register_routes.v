module handler

import log
import admin { Admin }

pub fn register_routes(mut app App) {
	app.register_controller[Admin, Context]('/admin', mut &Admin{}) or { log.error('${err}') }
}

pub fn before_request(mut ctx Context) bool {
	// $if trace_before_request ? {
	log.info('[veb] before_request: ${ctx.req.method} ${ctx.req.url}')
	// }
	return true
}
