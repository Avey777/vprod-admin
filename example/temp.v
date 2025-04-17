// module main

// import veb
// import db.mysql
// import time
// import orm

// @[table: 'sys_users']
// struct User {
// pub:
//     id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
//     name       string     @[immutable; sql: 'username'; sql_type: 'VARCHAR(255)'; unique]
//     created_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
//     updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP']
// }

// struct UserVo {
// pub:
//     id         string
//     name       string
//     created_at time.Time
//     updated_at time.Time
// }

// struct Context {
//     veb.Context
// }

// struct App {
//     veb.Middleware[Context]
// }

// fn main() {
//     port := 9009
//     mut app := &App{}
//     veb.run[App, Context](mut app, port)
// }

// @['/'; get]
// fn (app &App) index(mut ctx Context) veb.Result {
//     mut pool := db_pool()
//     defer { pool.close() }

//     mut pb := pool.acquire() or { panic('456') }
//     defer { pool.release(pb) }
//     dump(pb)

//     mut result0 := sql pb {
//         select from User
//     } or { panic('345') }
//     dump(result0)

//     mut qb := orm.new_query[User](pb)
//     result := qb.select() or { panic('123') }.query() or { panic('234') }
//     dump(result)

//     mut tmps := []UserVo{}
//     for r in result {
//         tmp := UserVo{
//             id:         r.id
//             name:       r.name
//             created_at: r.created_at or { time.unix(0) }
//             updated_at: r.updated_at
//         }
//         tmps << tmp
//     }

//     return ctx.json(tmps)
// }

// fn db_pool() mysql.ConnectionPool {
//     config := mysql.Config{
//         host:     'mysql2.sqlpub.com'
//         port:     3307
//         username: 'vcore_test'
//         password: 'wfo8wS7CylT0qIMg'
//         dbname:   'vcore_test'
//     }

//     mut pool := mysql.new_connection_pool(config, 10) or { panic('Failed to create pool: ${err}') }
//     dump(pool)

//     return pool
// }

module main

// import json
import x.json2

type Any = int | f64 | string | bool

fn main() {
	// mut q := json.encode(Any{
	// 	name: 'John'
	// 	age:  30
	// })
	// dump(q)

	mut q2 := json2.encode(Any{
		name:   'Jane'
		age:    25
		amount: 100.00
	})
	dump(q2)
}
