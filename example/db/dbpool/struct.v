module main

import pool
import time

// ======================================
// 数据库连接配置
// ======================================
pub struct DatabaseConfig {
pub mut:
	db_type    string // mysql | pgsql | postgres | postgresql
	host       string
	port       u32
	username   string
	password   string
	dbname     string
	ssl_verify bool @[default: false]

	//* pool 配置 */
	max_conns      int           = 100
	min_idle_conns int           = 10
	max_lifetime   time.Duration = 60 * time.minute
	idle_timeout   time.Duration = 30 * time.minute
	get_timeout    time.Duration = 3 * time.second
}

// ======================================
// 公共接口
// ======================================
pub interface DatabasePoolable {
mut:
	acquire() !(DbAdapter, &pool.ConnectionPoolable)
	release(conn &pool.ConnectionPoolable) !
	close()
}

// ======================================
// 统一数据库接口
// ======================================
pub interface DbAdapter {
mut:
	query(q string) ![]map[string]string
	execute(q string) !int
}
