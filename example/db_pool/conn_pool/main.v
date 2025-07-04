module main

import veb
import api { Context }
import dbpool
import rs_api
import log

struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
}

fn main() {
	mut conn := dbpool.init_pool() or {
		eprintln('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{}
	// 中间件：将 db_pool 注入到每个请求的 Context
	app.use(veb.MiddlewareOptions[Context]{
		handler: fn [conn] (mut ctx Context) bool {
			ctx.db_pool = conn
			return true
		}
	})
	app.handler_base(conn)
	veb.run[App, Context](mut app, 9008)
}

@['/index']
fn (mut app App) get_user(mut ctx Context) veb.Result {
	// 使用上下文中的连接池
	mut db, conn := ctx.db_pool.acquire() or { return ctx.text('获取连接失败: ${err}') }

	defer {
		ctx.db_pool.release(conn) or { eprintln('释放连接失败: ${err}') }
	}

	query := 'SELECT * FROM sys_users WHERE id = 1'
	rows := db.exec(query) or { return ctx.text('查询失败: ${err}') }

	return ctx.text(rows.str())
}

fn (mut app App) handler_base(conn &dbpool.DBConnPool) {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &rs_api.Base{}
	base_app.use(veb.MiddlewareOptions[Context]{
		handler: fn [conn] (mut ctx Context) bool {
			ctx.db_pool = conn
			return true
		}
	})
	app.register_controller[rs_api.Base, Context]('/base', mut base_app) or { log.error('${err}') }
}
