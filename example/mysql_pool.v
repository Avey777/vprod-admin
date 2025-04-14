module main

import db.mysql
import time

@[table: 'sys_users']
struct User {
  pub:
 	id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
 	name       ?string    @[immutable; sql: 'username'; sql_type: 'VARCHAR(255)'; unique]
 	created_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
 	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP']
}

fn main() {
  // 1. 配置数据库连接参数
  config := mysql.Config{
      host: "mysql2.sqlpub.com",
      port: 3307,
      username: "vcore_test",
      password: "wfo8wS7CylT0qIMg",
      dbname: "vcore_test",
      // timeout: 30 * time.second  // 连接超时设置[10](@ref)
  }
  // 2. 初始化连接池（建议大小10-20）
  mut pool := mysql.new_connection_pool(config, 1) or {
      panic("Failed to create pool: $err")
  }
  defer { pool.close() } // 程序退出时自动关闭
  dump(pool)

  mut pb := pool.acquire()!

  mut result := sql pb{
    select from User
 	} or { panic(err) }
 	dump(result)
  defer { pool.release(pb) }

  time.sleep(5 * time.second) // 等待协程完成
}
