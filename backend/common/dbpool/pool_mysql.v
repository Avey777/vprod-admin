module dbpool

import db.mysql

// pub struct ConnectionPoolMysql {
// mut:
// 	connections chan mysql.DB
// 	config      mysql.Config
// }

// new_connection_pool creates a new connection pool with the given size and configuration.
pub fn new_conn_pool_mysql(config mysql.Config, size int) !ConnectionPool {
	mut connections := chan mysql.DB{cap: size}
	for _ in 0 .. size {
		conn := mysql.connect(config)!
		connections <- conn
	}
	return ConnectionPool{
		connections_mysql: connections
		config_mysql:      config
	}
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPool) acquire_mysql() !mysql.DB {
	return <-pool.connections_mysql or {
		return error('Failed to acquire a connection from the pool')
	}
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPool) release_mysql(conn mysql.DB) {
	pool.connections_mysql <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPool) close_mysql() {
	for _ in 0 .. pool.connections_mysql.len {
		mut conn := <-pool.connections_mysql or { break }
		conn.close()
	}
}
