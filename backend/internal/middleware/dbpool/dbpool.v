module dbpool

import db.mysql
import pool
import time

// 数据库连接配置
struct DbConfig {
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
pub interface DatabaseMysqlPool {
mut:
	acquire() !(mysql.DB, &pool.ConnectionPoolable)
	release(conn &pool.ConnectionPoolable) !
	close()
}

// 连接池结构体
@[heap]
struct DatabasePoolImpl {
mut:
	inner &pool.ConnectionPool
}

// 创建新连接池 (返回接口类型) - 工厂函数返回接口类型
pub fn new_mysql_pool(config DbConfig) !&DatabaseMysqlPool {
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
	pool_instance := &DatabasePoolImpl{
		inner: inner_pool
	}
	return pool_instance
}

// 获取连接
pub fn (mut p DatabasePoolImpl) acquire() !(mysql.DB, &pool.ConnectionPoolable) {
	conn := p.inner.get()!
	return conn as mysql.DB, conn
}

// 释放连接
pub fn (mut p DatabasePoolImpl) release(conn &pool.ConnectionPoolable) ! {
	p.inner.put(conn)!
}

// 关闭连接池
pub fn (mut p DatabasePoolImpl) close() {
	p.inner.close()
}
