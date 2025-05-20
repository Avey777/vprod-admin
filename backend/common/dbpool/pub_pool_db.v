module dbpool

import db.mysql
import db.pg

const mysql_config = mysql.Config{
	host:     '127.0.0.1'
	port:     3306
	username: 'root'
	password: 'mysql_123456'
	dbname:   'vcore'
}

const pg_config = pg.Config{
	host:     'localhost'
	port:     5432
	user:     'postgres'
	password: '123456'
	dbname:   'redash'
}

// pub fn (db mysql.DB) DBConnection{}

pub fn new_conn_pool(type_db string) !ConnectionPool {
	if type_db == 'mysql' {
		mut pool := new_conn_pool_mysql(mysql_config, 5) or {
			panic('Failed to create mysql pool: ${err}')
		}
		return pool
	}
	if type_db == 'pgsql' {
		mut pool := new_conn_pool_pg(pg_config, 5) or {
			panic('Failed to create mysql pool: ${err}')
		}
		return pool
	}
	return ConnectionPool{}
}

const type_db = 'mysql'

pub fn (mut pool ConnectionPool) acquire() !(mysql.DB, pg.DB) {
	match type_db {
		'mysql' {
			conn := <-pool.connections_mysql or { return error('Failed mysql') }
			return conn, pg.DB{}
		}
		'pgsql' {
			conn := <-pool.connections_pg or { return error('Failed pgsql') }
			return mysql.DB{}, conn
		}
		else {
			return mysql.DB{}, pg.DB{}
		}
	}
}

type DBType = pg.DB | mysql.DB

pub fn (mut pool ConnectionPool) release(conn DBType) {
	match conn {
		mysql.DB {
			pool.connections_mysql <- conn
		}
		pg.DB {
			pool.connections_pg <- conn
		}
	}
}

pub fn (mut pool ConnectionPool) close() {
	match type_db {
		'mysql' {
			for _ in 0 .. pool.connections_mysql.len {
				mut conn := <-pool.connections_mysql or { break }
				conn.close()
			}
		}
		'pgsql' {
			for _ in 0 .. pool.connections_pg.len {
				mut conn := <-pool.connections_pg or { break }
				conn.close()
			}
		}
		else {}
	}
}
