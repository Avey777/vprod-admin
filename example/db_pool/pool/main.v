module main

import veb
import api { Context }
import dbpool { DBConnPool }
import rs_api
import log

struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
mut:
	db_pool &DBConnPool // 使用封装的连接池
}

fn main() {
	mut conn := dbpool.init_pool() or {
		eprintln('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{
		db_pool: conn
	}
	app.handler_base()
	veb.run[App, Context](mut app, 9008)
}

@['/']
fn (mut app App) get_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 直接使用app中的db_pool获取连接
	mut db, conn := app.db_pool.acquire() or { return ctx.text('获取连接失败: ${err}') }

	// 确保连接会被释放
	defer {
		app.db_pool.release(conn) or { eprintln('释放连接失败: ${err}') }
	}

	// 执行SQL查询
	query := 'SELECT * FROM sys_users WHERE id = 1'
	rows := db.exec(query) or { return ctx.text('查询失败: ${err}') }

	// 返回查询结果
	return ctx.text(rows.str())
}

fn (mut app App) handler_base() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// 方式一: 直接使用中间件，适合对单个控制器单独使用中间件
	mut base_app := &rs_api.Base{
		db_pool: app.db_pool
	}

	app.register_controller[rs_api.Base, Context]('/base', mut base_app) or { log.error('${err}') }
}
