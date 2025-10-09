module main

import veb
import log
import structs { Context }
import routes { AliasApp }

const cors_origin = ['*', 'xx.com']

pub fn app_start() {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut app := &AliasApp{}
	app.register_routes()

	app.use(veb.cors[Context](veb.CorsOptions{
		origins:         cors_origin
		allowed_methods: [.get, .head, .patch, .put, .post, .delete, .options]
	}))

	port := 9009
	veb.run_at[AliasApp, Context](mut app,
		host:               ''
		port:               port
		family:             .ip6
		timeout_in_seconds: 30
	) or { panic(err) }
}
