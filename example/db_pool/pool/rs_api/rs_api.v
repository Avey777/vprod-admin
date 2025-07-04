module rs_api

import veb
import log
import api { Context }
import dbpool { DBConnPool }

// type DBConnPool = pool_p.DBConnPool

pub struct Base {
	veb.Middleware[Context] // pub mut:
pub mut:
	db_pool &DBConnPool // 使用封装的连接池
}

@['/1']
pub fn (mut app Base) get_user(mut ctx Context) veb.Result {
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
	// return ctx.text('132')
}
