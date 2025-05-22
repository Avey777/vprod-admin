module main

import db.mysql
import db.pg

type DBconfig = mysql.Config | pg.Config

struct ConnectionPoolGeneric[T] {
mut:
	connections chan T   // mysql.DB, pg.DB
	config      DBconfig // mysql.Config, pg.Config
}

pub fn new_conn_pool[T](conf DBconfig, size int) !&ConnectionPoolGeneric[T] {
	$if conf is mysql.Config {
		mysql_conf := conf as mysql.Config
		mut pool := &ConnectionPoolGeneric[mysql.DB]{
			connections: chan mysql.DB{cap: size}
			config:      mysql_conf
		}
		for _ in 0 .. size {
			conn := mysql.connect(mysql_conf)!
			poo.connections <- conn
		}
		return pool
	} $else $if conf is pg.Config {
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
	}$else{
	  return error('')
	}
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
		conn.close()
	}
}


const config = mysql.Config{
	host:     '127.0.0.1'
	port:     3306
	username: 'root'
	password: 'mysql_123456'
	dbname:   'vcore'
}

fn main() {
	mut pool := new_conn_pool[mysql.DB](config, 5) or {
		panic('Failed to create mysql pool: ${err}')
	}
	dump(pool)
	db := pool.acquire() or { panic(err) }
	dump(db)
	data := db.exec('select 1')!
	dump(data)
	assert data[0] == mysql.Row{
		vals: ['1']
	}
	pool.release(db)
	pool.close()
}
