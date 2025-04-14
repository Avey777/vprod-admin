module main

import db.mysql
import time

@[table: 'sys_users']
struct User {
  pub:
 	id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
 	name       ?string    @[immutable; sql: 'name'; sql_type: 'VARCHAR(255)'; unique]
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

  // mut result := sql pool{
  //   select from User
 	// } or { panic(err) }
 	// dump(result)
}
  // 3. 使用连接执行查询
  // for _ in 0..5 { // 模拟并发请求
  //     go handle_query(mut pool)
  // }

  // time.sleep(5 * time.second) // 等待协程完成
// }

// fn handle_query(mut pool mysql.ConnectionPool) {
//     // 4. 获取连接（带超时机制）
//     mut conn := pool.acquire() or {
//         eprintln("Connection acquire failed: $err")
//         return
//     }
//     defer pool.release(conn) // 确保连接释放

//     // 5. 连接健康检查
//     if is_alive := conn.ping() {
//         eprintln("Connection is invalid")
//         return
//     }

//     // 6. 执行事务操作
//     tx := conn.begin() or {
//         eprintln("Transaction start failed: $err")
//         return
//     }

//     // 7. 执行查询
//     result := tx.query("SELECT * FROM users WHERE id = ?", [1]) or {
//         tx.rollback()
//         eprintln("Query failed: $err")
//         return
//     }

//     // 8. 提交事务
//     tx.commit() or {
//         eprintln("Commit failed: $err")
//         return
//     }

//     // 9. 处理结果
//     for row in result.rows() {
//         println("User: $row")
//     }
// }
