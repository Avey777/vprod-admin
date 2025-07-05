module middleware

import veb
import internal.structs { Context }
import internal.middleware.dbpool

// 初始化数据库连接池
pub fn init_db_pool() !&dbpool.DatabasePoolable {
	mut config_db := dbpool.DatabaseConfig{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}

	mut conn := dbpool.new_db_pool(config_db) or { return err }
	return conn
}

// 独立中间件生成函数
pub fn db_middleware(conn &dbpool.DatabasePoolable) veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: fn [conn] (mut ctx Context) bool {
			ctx.dbpool = unsafe { conn } //分配到堆上，需要使用 unsafe
			return true // 返回 true 表示继续处理请求
		}
	}
}
