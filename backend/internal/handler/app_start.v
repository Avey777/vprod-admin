module handler

import veb
import log
import internal.structs { Context }
import internal.middleware
import internal.middleware.conf


pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

/*******init_config_loader********/
	log.info('init_config_loader()')
	mut loader := conf.new_config_loader()
	doc := loader.get_config() or { panic('Failed to load config: ${err}') }
	dump(doc)
/********init_config_loader*******/

/*******init_db_pool********/
	log.info('init_db_pool()')
	mut conn := middleware.init_db_pool(doc) or {
		log.info('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}
/*******init_db_pool********/

	mut app := &App{} // 实例化 App 结构体 并返回指针
	app.use(middleware.config_middle(doc))
	app.use(middleware.db_middleware(conn))

	app.register_handlers(conn, doc) // veb.Controller  使用路由控制器 | handler/register_routes.v

	veb.run_at[App, Context](mut app,
		host:               ''
		port:               doc.web.port
		family:             .ip6
		timeout_in_seconds: doc.web.timeout
	) or { return }
}
