module main

import db.mysql
import db.pg

struct ConnectionPool[T, U] {
mut:
	connections chan T // mysql.DB, pg.DB
	config      U      // mysql.Config, pg.Config
}

// 创建连接池（通过泛型指定类型）
pub fn new_db_pool[T, U](config U, size int) !&ConnectionPool[T, U] {
	$if T is mysql.Config {
		mut pool_mysql := &ConnectionPool[mysql.DB, mysql.Config]{
			connections: chan mysql.DB{cap: size}
			config:      config
		}
		for _ in 0 .. size {
			conn := mysql.connect(config)!
			pool_mysql.connections <- conn
		}
		return pool_mysql
	} $else $if T is pg.Config {
		mut pool_pg := &ConnectionPool[pg.DB, pg.Config]{
			connections: chan pg.DB{cap: size}
			config:      config
		}
		for _ in 0 .. size {
			conn := pg.connect(config)!
			pool_pg.connections <- conn
		}
		return pool_pg
	}

	return error('Unsupported databases')
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPool[T, U]) acquire() !T {
	conn := <-pool.connections or { return error('Failed mysql') }
	return conn
}

// release returns a connection back to the pool. | 释放将连接返回到池中
pub fn (mut pool ConnectionPool[T, U]) release(conn T) {
	pool.connections <- conn
}

// close closes all connections in the pool | 关闭池中的所有连接
pub fn (mut pool ConnectionPool[T, U]) close() {
	for _ in 0 .. pool.connections.len {
		mut conn := <-pool.connections or { break }
		conn.close()
	}
}

fn main() {
	mut pool := new_db_pool[mysql.DB, mysql.Config](mysql.Config{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}, 5) or { panic('Failed to create mysql pool: ${err}') }
	// mut pool := new_db_pool[pg.DB, pg.Config](pg.Config{
	// 	host:     'localhost'
	// 	port:     5432
	// 	user:     'postgres'
	// 	password: '123456'
	// 	dbname:   'redash'
	// }, 5) or { panic('Failed to create pg pool: ${err}') }
	dump(pool)
	dump(pool)
	db := pool.acquire() or { panic(err) }
	dump(db)
	a := db.exec('select 1')!
	dump(a)

	pool.release(db)
	pool.close()
}
