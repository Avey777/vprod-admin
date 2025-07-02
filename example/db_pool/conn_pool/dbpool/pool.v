
module dbpool

import db.mysql
import pool
import time

// type DBConnPool = api.DBConnPool

// 数据库连接配置
struct DbConfig {
	host           string
	port           u32
	username       string
	password       string
	dbname         string
	max_conns      int           = 10
	min_idle_conns int           = 2
	max_lifetime   time.Duration = 1 * time.hour
	idle_timeout   time.Duration = 30 * time.minute
	get_timeout    time.Duration = 5 * time.second
}

// 连接池结构体
@[heap]
pub struct DBConnPool {
pub mut:
	inner &pool.ConnectionPool
}

// 创建新连接池
pub fn new_db_pool(config DbConfig) !&DBConnPool {
	create_conn := fn [config] () !&pool.ConnectionPoolable {
		mut db := mysql.connect(mysql.Config{
			host:     config.host
			port:     config.port
			username: config.username
			password: config.password
			dbname:   config.dbname
		})!
		return &db
	}

	pool_conf := pool.ConnectionPoolConfig{
		max_conns:      config.max_conns
		min_idle_conns: config.min_idle_conns
		max_lifetime:   config.max_lifetime
		idle_timeout:   config.idle_timeout
		get_timeout:    config.get_timeout
	}

	inner_pool := pool.new_connection_pool(create_conn, pool_conf)!
	return &DBConnPool{
		inner: inner_pool
	}
}

// 获取连接
pub fn (mut p DBConnPool) acquire() !(mysql.DB, &pool.ConnectionPoolable) {
	conn := p.inner.get()!
	return conn as mysql.DB, conn
}

// 释放连接
pub fn (mut p DBConnPool) release(conn &pool.ConnectionPoolable) ! {
	p.inner.put(conn)!
}

// 关闭连接池
pub fn (mut p DBConnPool) close() {
	p.inner.close()
}

pub fn init_pool() !&DBConnPool {
	config := DbConfig{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}
	return new_db_pool(config) or {
		eprintln('连接池创建失败: ${err}')
		return err
	}
}
