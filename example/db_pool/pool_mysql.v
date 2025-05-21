module main

import db.mysql

pub struct ConnectionPoolMysql {
mut:
	connections chan mysql.DB
	config      mysql.Config
}

// new_connection_pool creates a new connection pool with the given size and configuration.
pub fn new_connection_pool_mysql(config mysql.Config, size int) !ConnectionPoolMysql {
	mut connections := chan mysql.DB{cap: size}
	for _ in 0 .. size {
		conn := mysql.connect(config)!
		connections <- conn
	}
	return ConnectionPoolMysql{
		connections: connections
		config:      config
	}
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPoolMysql) acquire_mysql() !mysql.DB {
	return <-pool.connections or { return error('Failed to acquire a connection from the pool') }
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPoolMysql) release_mysql(conn mysql.DB) {
	pool.connections <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPoolMysql) close_mysql() {
	for _ in 0 .. pool.connections.len {
		mut conn := <-pool.connections or { break }
		conn.close()
	}
}

fn main() {
	mut pool := new_connection_pool_mysql(mysql.Config{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}, 5) or { panic('Failed to create mysql pool: ${err}') }
	dump(pool)

	db := pool.acquire_mysql() or { panic(err) }
	dump(db)
	dump('pool.acquire')
	db.exec('create table if not exists user (id serial primary key, name text not null)') or {
		panic('Failed to create table users: ${err}')
	}
	pool.release_mysql(db)
	dump('pool.release')
	pool.close_mysql()
	dump('pool.close')
}
