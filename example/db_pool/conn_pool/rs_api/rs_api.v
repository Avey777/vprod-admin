module rs_api

import veb
import log
import api { Context }

pub struct Base {
	veb.Middleware[Context]
}

@['/index']
fn (mut app Base) get_user(mut ctx Context) veb.Result {
	log.info('4645646')
	// 使用上下文中的连接池
	mut db, conn := ctx.db_pool.acquire() or { return ctx.text('获取连接失败: ${err}') }

	defer {
		ctx.db_pool.release(conn) or { eprintln('释放连接失败: ${err}') }
	}

	query := 'SELECT * FROM sys_users WHERE id = 1'
	rows := db.exec(query) or { return ctx.text('查询失败: ${err}') }

	return ctx.text(rows.str())
}
