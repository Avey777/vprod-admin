module handler

import veb
import log
import internal.config
import internal.structs { Context }
import internal.middleware

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	doc := config.toml_load()

	log.info('init_db_pool()')
	mut conn := middleware.init_db_pool() or {
		log.info('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{} // 实例化 App 结构体 并返回指针
	app.use(middleware.db_middleware(conn))

	app.register_handlers(conn) // veb.Controller  使用路由控制器 | handler/register_routes.v

	mut port := doc.value('web.port').int()
	mut timeout_seconds := doc.value('web.timeout').int()
	veb.run_at[App, Context](mut app,
		host:               ''
		port:               port
		family:             .ip6
		timeout_in_seconds: timeout_seconds
	) or { return }
}
