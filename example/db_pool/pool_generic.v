module main

import db.mysql
import db.pg

type DBD = mysql.DB | pg.DB
type DBconfig = mysql.Config | pg.Config

struct ConnectionPool {
mut:
	connections chan DBD // mysql.DB, pg.DB
	config      DBconfig // mysql.Config, pg.Config
}

// 创建连接池（通过泛型指定类型）
pub fn new_db_pool(conf DBconfig, size int) !&ConnectionPool {
	mut pool := &ConnectionPool{
		connections: chan DBD{cap: size}
		config:      conf
	}
	match conf {
		mysql.Config {
			mysql_conf := conf as mysql.Config
			for _ in 0 .. size {
				conn := mysql.connect(mysql_conf)!
				pool.connections <- conn
			}
		}
		pg.Config {
			pg_conf := conf as pg.Config
			for _ in 0 .. size {
				conn := pg.connect(pg_conf)!
				pool.connections <- conn
			}
		}
	}

	return pool
}

// acquire gets a connection from the pool | 从池中获取连接
pub fn (mut pool ConnectionPool) acquire() !DBD {
	conn := <-pool.connections or { return error('Failed mysql') }
	return conn
}

// // release returns a connection back to the pool. | 释放将连接返回到池中
// pub fn (mut pool ConnectionPool) release(conn DBD) {
// 	pool.connections <- conn
// }

fn main() {
	mut pool := new_db_pool(DBconfig{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}, 5) or { panic('Failed to create mysql pool: ${err}') }
	dump(pool)
	db := pool.acquire() or { panic(err) }
	dump(db)
	dbb := db as mysql.DB
	a := dbb.exec('select 1')!
	dump(a)
}

// pool.release(db)
// pool.close()
// }

// // acquire gets a connection from the pool | 从池中获取连接
// pub fn (mut pool ConnectionPool[T, U]) acquire() !T {
// 	conn := <-pool.connections or { return error('Failed mysql') }
// 	return conn
// }

// // release returns a connection back to the pool. | 释放将连接返回到池中
// pub fn (mut pool ConnectionPool[T, U]) release(conn T) {
// 	pool.connections <- conn
// }

// // close closes all connections in the pool | 关闭池中的所有连接
// pub fn (mut pool ConnectionPool[T, U]) close() {
// 	for _ in 0 .. pool.connections.len {
// 		mut conn := <-pool.connections or { break }
// 		conn.close()
// 	}
// }
