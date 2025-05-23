module dbpool

import db.mysql

// 全局实例（正确声明方式）
__global g_conns_pool ConnectionPool

// 初始化连接池（程序启动时调用）
pub fn init_pool(config mysql.Config, pool_size int) !string {
	mut g_conn := &g_conns_pool
	g_conn.connections = chan mysql.DB{cap: pool_size}
	g_conn.config = config

	for _ in 0 .. pool_size {
		g_conn.connections <- mysql.connect(config) or { return '' }
	}
	return ''
}

// 获取连接（阻塞式）
pub fn acquire() mysql.DB {
	return <-g_conns_pool.connections
}

// 释放连接
pub fn release(conn mysql.DB) {
	g_conns_pool.connections <- conn
}
