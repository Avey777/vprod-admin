module dbpool

import db.mysql
import pool
import time

// 数据库连接配置
pub struct DatabaseConfig {
pub mut:
	type           string
	host           string
	port           u32
	username       string
	password       string
	dbname         string
	max_conns      int           = 100
	min_idle_conns int           = 10
	max_lifetime   time.Duration = 1 * time.hour
	idle_timeout   time.Duration = 30 * time.minute
	get_timeout    time.Duration = 5 * time.second
}

// 公共接口
pub interface DatabasePoolable {
mut:
	acquire() !(mysql.DB, &pool.ConnectionPoolable)
	release(conn &pool.ConnectionPoolable) !
	close()
}

// 连接池结构体，和APP同生命周期，分配到堆上
@[heap]
pub struct DatabasePool implements DatabasePoolable {
pub mut:
	inner &pool.ConnectionPool
}

// 创建新连接池
pub fn new_db_pool(config DatabaseConfig) !&DatabasePoolable {
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
	pool_instance := &DatabasePool{
		inner: inner_pool
	}
	return pool_instance
}

// 获取连接
pub fn (mut p DatabasePool) acquire() !(mysql.DB, &pool.ConnectionPoolable) {
	conn := p.inner.get()!
	// 安全类型转换
	return conn as mysql.DB, conn
}

// 释放连接
pub fn (mut p DatabasePool) release(conn &pool.ConnectionPoolable) ! {
	p.inner.put(conn)!
}

// 关闭连接池
pub fn (mut p DatabasePool) close() {
	p.inner.close()
}
