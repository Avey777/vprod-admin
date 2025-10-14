module dbpool

import db.mysql
import db.pg

type DBconfig = mysql.Config | pg.Config

struct ConnectionPoolGeneric[T] {
mut:
	connections chan T   // mysql.DB, pg.DB
	config      DBconfig // mysql.Config, pg.Config
}

pub fn new_conn_pool[T](conf DBconfig, size int) !&ConnectionPoolGeneric[T] {
	$if T is mysql.DB {
		mysql_conf := conf as mysql.Config
		mut pool := &ConnectionPoolGeneric[mysql.DB]{
			connections: chan mysql.DB{cap: size}
			config:      mysql_conf
		}
		for _ in 0 .. size {
			conn := mysql.connect(mysql_conf)!
			pool.connections <- conn
		}
		return pool
	} $else $if T is pg.DB {
		pg_conf := conf as pg.Config
		mut pool := &ConnectionPoolGeneric[pg.DB]{
			connections: chan pg.DB{cap: size}
			config:      pg_conf
		}
		for _ in 0 .. size {
			conn := pg.connect(pg_conf)!
			pool.connections <- conn
		}
		return pool
	}
	return error('')
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPoolGeneric[T]) acquire() !T {
	conn := <-pool.connections or { return error('Failed mysql') }
	return conn
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPoolGeneric[T]) release(conn T) {
	pool.connections <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPoolGeneric[T]) close() {
	for _ in 0 .. pool.connections.len {
		mut conn := <-pool.connections or { break }
		conn.close() or { panic }
	}
}
