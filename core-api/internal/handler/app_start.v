module handler

import veb
import log
import internal.config { toml_load }
import internal.structs { Context }

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	doc := toml_load()

	mut app := &App{} // 实例化 App 结构体 并返回指针
	register_handlers(mut app) // veb.Controller  使用路由控制器 | handler/register_routes.v

	mut port := doc.value('web.port').int()
	mut timeout_seconds := doc.value('web.timeout').int()
	veb.run_at[App, Context](mut app,
		host:               ''
		port:               port
		family:             .ip6
		timeout_in_seconds: timeout_seconds
	) or { panic(err) }
}
