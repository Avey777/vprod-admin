module handler

import veb
import log
// import config
// import rand
import structt

const cors_origin = ['*', 'xx.com']

// pub struct Context {
// 	veb.Context
// }

pub struct App {
	veb.Middleware[structt.Context]
	veb.Controller
	veb.StaticHandler
}

pub fn new_app() {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut app := &App{}
	register_routes(mut app)

	app.use(veb.cors[structt.Context](veb.CorsOptions{
		origins:         cors_origin
		allowed_methods: [.get, .head, .patch, .put, .post, .delete, .options]
	}))

	port := 9009
	veb.run_at[App, structt.Context](mut app,
		host:               ''
		port:               port
		family:             .ip6
		timeout_in_seconds: 30
	) or { panic(err) }
}

@['/get'; get]
pub fn (app &App) index(mut ctx structt.Context) veb.Result {
	// log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json('req success')
}
