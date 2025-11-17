module main

import veb
import log
import internal.structs { Context }
import internal.middleware
import internal.config
import internal.i18n
import internal.routes { AliasApp }

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	//*******init_config_loader********/
	log.debug('init_config_loader()')
	mut loader := config.new_config_loader()
	doc := loader.get_config() or { panic('Failed to load config: ${err}') }
	log.debug('${doc}')
	//********init_config_loader*******/

	i18n_app := i18n.new_i18n('./etc/locales', 'zh') or { return }

	//*******init_db_pool********/
	log.debug('init_db_pool()')
	mut conn := middleware.init_db_pool(doc) or {
		log.warn('db_pool 初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}
	//*******init_db_pool********/

	mut app := &AliasApp{
		started: chan bool{cap: 1} // 关键：正确初始化通道
	} // 实例化 App 结构体 并返回指针

	app.use(middleware.config_middle(doc))
	app.use(middleware.db_middleware(conn))
	app.use(middleware.i18n_middleware(i18n_app))
	app.use(veb.encode_gzip[Context]())

	app.routes_ifdef(conn, doc) // veb.Controller  使用路由控制器 | routes/routes_ifdef.v

	veb.run_at[AliasApp, Context](mut app,
		host:               ''
		port:               doc.web.port
		family:             .ip6
		timeout_in_seconds: doc.web.timeout
	) or { return }
}
