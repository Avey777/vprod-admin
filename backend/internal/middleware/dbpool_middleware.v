module middleware

import internal.structs { Context }
import internal.middleware.dbpool

// 独立中间件生成函数
fn db_middleware(conn &dbpool.DatabasePool) fn (mut ctx Context) bool {
	// 返回闭包函数并捕获conn
	return fn [conn] (mut ctx Context) bool {
		ctx.dbpool = conn
		return true
	}
}
