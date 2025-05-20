module dbpool

import db.pg
// pub struct ConnectionPoolPg {
// mut:
// 	connections chan pg.DB
// 	config      pg.Config
// }

// new_connection_pool creates a new connection pool with the given size and configuration.
pub fn new_conn_pool_pg(config pg.Config, size int) !ConnectionPool {
	mut connections := chan pg.DB{cap: size}
	for _ in 0 .. size {
		conn := pg.connect(config)!
		connections <- conn
	}
	return ConnectionPool{
		connections_pg: connections
		config_pg:      config
	}
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPool) acquire_pg() !pg.DB {
	return <-pool.connections_pg or { return error('Failed to acquire a connection from the pool') }
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPool) release_pg(conn pg.DB) {
	pool.connections_pg <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPool) close_pg() {
	for _ in 0 .. pool.connections_pg.len {
		mut conn := <-pool.connections_pg or { break }
		conn.close()
	}
}
