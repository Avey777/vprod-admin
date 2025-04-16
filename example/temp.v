module main

import veb
import db.mysql
import time
import orm

@[table: 'sys_users']
struct User {
pub:
	id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
	name       string    @[immutable; sql: 'username'; sql_type: 'VARCHAR(255)'; unique]
	created_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP']
}

struct Context {
	veb.Context
}

struct App {
	veb.Middleware[Context]
}

fn main() {
	port := 9009
	mut app := &App{}
	veb.run[App, Context](mut app, port)
}

@['/'; get]
fn (app &App) index(mut ctx Context) !veb.Result {
	mut pool := db_pool()
	defer { pool.close() }

	mut pb := pool.acquire()!
	defer { pool.release(pb) }
	dump(pb)

	mut result0 := sql pb {
		select from User
	}!
	dump(result0)

	mut qb := orm.new_query[User](pb)
	result := qb.select()!.query()!
	dump(result)

	return ctx.json(result)
}

fn db_pool() mysql.ConnectionPool {
	config := mysql.Config{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}

	mut pool := mysql.new_connection_pool(config, 10) or { panic('Failed to create pool: ${err}') }
	dump(pool)

	return pool
}
