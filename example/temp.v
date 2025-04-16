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

import time
import orm
import db.mysql

@[table: 'sys_users']
struct User {
pub:
  id            string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
  name          string     @[immutable; sql: 'username'; sql_type: 'VARCHAR(255)'; unique]
  department_id ?string    @[omitempty; optional; sql_type: 'VARCHAR(255)']
  created_at    time.Time  @[omitempty; sql_type: 'TIMESTAMP']
  updated_at    time.Time  @[omitempty; sql_type: 'TIMESTAMP']
}

fn main() {

 	mut db := db_mysql()!
	defer { db.close() }

	// //normal
	// department_id := 0
	// username := ""

	// //normal
	// department_id := 0
	// username := "354"


	//v panic
	department_id := 1
	username := "354"

	mut sys_user := orm.new_query[User](db)

 	mut query := sys_user.select()!
	if department_id != 0 {
     query = query.where('department_id = ?', department_id)!
   }
   if username != '' {
       query = query.where('username = ?', username)!
   }
	result := query.limit(3)!.offset(0)!.query()!

	dump(result)
}

fn db_mysql() !mysql.DB {
	mut mysql_config := mysql.Config{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}
	mut conn := mysql.connect(mysql_config) or { return err }
	return conn
}
