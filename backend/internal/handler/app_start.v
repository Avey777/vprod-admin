module handler

import veb
import log
import internal.config { toml_load }
import internal.structs { Context }
import internal.middleware.dbpool

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	doc := toml_load()

	log.info('init_db_pool()')
	mut conn := init_db_pool() or {
		eprintln('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{} // 实例化 App 结构体 并返回指针
	app.use(veb.MiddlewareOptions[Context]{
		handler: fn [conn] (mut ctx Context) bool {
			ctx.dbpool = conn
			return true
		}
	})
	app.register_handlers() // veb.Controller  使用路由控制器 | handler/register_routes.v

	mut port := doc.value('web.port').int()
	mut timeout_seconds := doc.value('web.timeout').int()
	veb.run_at[App, Context](mut app,
		host:               ''
		port:               port
		family:             .ip6
		timeout_in_seconds: timeout_seconds
	) or { panic(err) }
}

pub fn init_db_pool() !&dbpool.DatabasePoolable {
	mut config_db := dbpool.DatabaseConfig{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}
	return dbpool.new_db_pool(config_db) or {
		eprintln('连接池创建失败: ${err}')
		return err
	}
}
