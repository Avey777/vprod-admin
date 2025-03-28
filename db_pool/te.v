// 连接池核心模块
module main

import time
import sync

// 创建新连接池
pub fn new_pool(factory fn () orm.Connection, config Config) &ConnectionPool {
	return &ConnectionPool{
		factory: factory
		config:  config
	}
}

// 获取连接 (带超时)
pub fn (mut p ConnectionPool) acquire(timeout int) !orm.Connection {
	p.mu.lock()
	defer { p.mu.unlock() }

	// 尝试获取空闲连接
	for p.conns.len > 0 {
		mut conn := p.conns.pop()
		if is_connection_alive(conn) {
			p.active++
			return conn
		}
	}

	// 创建新连接
	if p.active < p.config.max_size {
		new_conn := p.factory()
		p.active++
		return new_conn
	}

	// // 等待连接释放 (带超时)
	// start_time := time.now()
	// for {
	// 	elapsed := time.since(start_time)
	// 	if elapsed > timeout {
	// 		return error('Connection timeout after ${timeout}ms')
	// 	}

	// 	if p.conns.len > 0 {
	// 		mut conn := p.conns.pop()
	// 		if is_connection_alive(conn) {
	// 			p.active++
	// 			return conn
	// 		}
	// 	}
	// 	time.sleep(100 * time.millisecond)
	// }
}

// // 释放连接
// pub fn (mut p ConnectionPool) release(conn orm.Connection) {
// 	p.mu.lock()
// 	defer { p.mu.unlock() }

// 	// 连接健康检查
// 	if !is_connection_alive(conn) {
// 		p.active--
// 		return
// 	}

// 	// 放回池或关闭
// 	if p.conns.len < p.config.max_idle {
// 		p.conns << conn
// 	} else {
// 		conn.close() // 假设Connection有close方法
// 	}
// 	p.active--
// }

// // 健康检查
// fn is_connection_alive(conn orm.Connection) bool {
// 	// 实现心跳检测逻辑
// 	return true
// }

// /
