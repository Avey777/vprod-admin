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

// module main
// import time
// import db.sqlite
// import orm

// fn main() {
//   mut db := sqlite.connect(':memory:')!
// 	defer { db.close() or {} }
//   sql db{
//     create table SysUser
//     create table SysUserRole
//   }!

// 	users := SysUser{
//      id: '001'
//      username: 'name1'
//      created_at: time.now()
//      updated_at: time.now()
// 	}

//   mut user_roles := []SysUserRole{}
//   user_roles << [SysUserRole{
//       user_id: '001',
//       role_id: '4'
//   },
//   SysUserRole{
//     user_id: '001',
//     role_id: '5',
//   },
//   SysUserRole{
//     user_id: '001',
//     role_id: '6',
//   }]

//   dump(user_roles)
//   dump(users)

//   mut sys_user := orm.new_query[SysUser](db)
//   mut user_role := orm.new_query[SysUserRole](db)

//   sys_user.insert(users)!
//   println('users')
//   user_role.insert_many(user_roles)!
//   println('user_roles')

//   mut user_1 := sql db{
//     select from SysUser
//   }!
//   dump(user_1)

//   mut user_roles_1 := sql db{
//     select from SysUserRole
//   }!
//   dump(user_roles_1)
// }

// // 用户表
// @[table: 'sys_users']
// struct SysUser {
// pub:
// 	id            string     @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID rand.uuid_v4()']
// 	username      string     @[omitempty; required; sql: 'username'; sql_type: 'VARCHAR(255)'; unique: 'username'; zcomments: 'User`s login name | 登录名']
// 	created_at    time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
// 	updated_at    ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
// }

// // 用户角色关联表(一个用户可以拥有多个角色)
// @[table: 'sys_user_roles']
// struct SysUserRole {
// 	user_id string @[sql_type: 'CHAR(36)'; zcomments: '用户ID']
// 	role_id string @[sql_type: 'CHAR(36)'; zcomments: '角色ID']
// }
import benchmark
fn main() {
  mut b := benchmark.start()
    // 原始数组（假设元素为字符串）
  arr := ['你好', '世界', '人']
  result := arr.join(', ')

  println(result) // 输出：('12', '123')
  b.measure('')
}
