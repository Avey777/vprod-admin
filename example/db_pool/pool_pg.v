module main

import db.pg

pub struct ConnectionPoolPg {
mut:
	connections chan pg.DB
	config      pg.Config
}

// new_connection_pool creates a new connection pool with the given size and configuration.
pub fn new_connection_pool_pg(config pg.Config, size int) !ConnectionPoolPg {
	mut connections := chan pg.DB{cap: size}
	for _ in 0 .. size {
		conn := pg.connect(config)!
		connections <- conn
	}
	return ConnectionPoolPg{
		connections: connections
		config:      config
	}
}

// acquire gets a connection from the pool
pub fn (mut pool ConnectionPoolPg) acquire_pg() !pg.DB {
	return <-pool.connections or { return error('Failed to acquire a connection from the pool') }
}

// release returns a connection back to the pool.
pub fn (mut pool ConnectionPoolPg) release_pg(conn pg.DB) {
	pool.connections <- conn
}

// close closes all connections in the pool.
pub fn (mut pool ConnectionPoolPg) close_pg() {
	for _ in 0 .. pool.connections.len {
		mut conn := <-pool.connections or { break }
		conn.close()
	}
}

fn main() {
	mut pool := new_connection_pool_pg(pg.Config{
		host:     'localhost'
		port:     5432
		user:     'postgres'
		password: '123456'
		dbname:   'redash'
	}, 5) or { panic('Failed to create pg pool: ${err}') }
	dump(pool)

	db := pool.acquire_pg() or { panic(err) }
	db.exec('create table if not exists users (id serial primary key, name text not null)') or {
		panic('Failed to create table users: ${err}')
	}
	pool.release_pg(db)

	pool.close_pg()
}
