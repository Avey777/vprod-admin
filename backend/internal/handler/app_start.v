module handler

import veb
import log
// import internal.config
import internal.structs { Context }
import internal.middleware
import internal.middleware.config_loader

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// doc := config.toml_load()

	log.info('new_config_loader()')
	mut loader := config_loader.new_config_loader()
	doc_conf := loader.get_config() or { panic('Failed to load config: ${err}') }
	dump(doc_conf)

	log.info('init_db_pool()')
	mut conn := middleware.init_db_pool() or {
		log.info('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{} // 实例化 App 结构体 并返回指针
	app.use(middleware.config_middle(doc_conf))
	app.use(middleware.db_middleware(conn))

	app.register_handlers(conn) // veb.Controller  使用路由控制器 | handler/register_routes.v

	// mut port := doc.value('web.port').int()
	// mut timeout_seconds := doc.value('web.timeout').int()
	veb.run_at[App, Context](mut app,
		host:               ''
		port:               doc_conf.web.port
		family:             .ip6
		timeout_in_seconds: doc_conf.web.timeout
	) or { return }
}
