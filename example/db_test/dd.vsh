module main

import db.pg

// 简化配置
pub struct DatabaseConfig {
pub:
	db_type string
	host    string
	port    u32
}

// 统一接口
pub interface DbConnection {
	query(q string) ![]map[string]string
}

// PostgreSQL 连接实现
pub struct PgConnection {
mut:
	db pg.DB
}

pub fn new_pg_connection(conf DatabaseConfig) !&PgConnection {
	db := pg.connect(pg.Config{
		host:     conf.host
		port:     int(conf.port)
		user:     'postgres'
		password: 'password'
		dbname:   'test_db'
	})!
	return &PgConnection{db}
}

pub fn (c &PgConnection) query(q string) ![]map[string]string {
	res := c.db.exec_result(q)!
	mut rows := []map[string]string{}

	for row in res.rows {
		mut m := map[string]string{}
		for col, idx in res.cols {
			// 修复这里的问题：正确的类型转换
			val := row.vals[idx] or { '' } as string
			m[col] = val
		}
		rows << m
	}
	return rows
}

// 连接池相关
pub fn (c &PgConnection) validate() !bool {
	return true
}

pub fn (c &PgConnection) reset() ! {}

pub fn (c &PgConnection) close() ! {}

// 主函数测试
fn main() {
	conf := DatabaseConfig{
		db_type: 'postgresql'
		host:    'localhost'
		port:    5432
	}

	// 测试 PostgreSQL 连接
	mut conn := new_pg_connection(conf) or {
		println('Failed to connect: ${err}')
		return
	}

	// 这里会触发编译错误
	result := conn.query('SELECT 1 as test_value') or {
		println('Query failed: ${err}')
		return
	}

	println('Result: ${result}')
}
