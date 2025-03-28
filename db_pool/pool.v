// module main

// // 1) 定义一个最简单的 mysql.Config 结构体
// pub struct Config {
// 	host     string
// 	port     u32
// 	username string
// 	password string
// 	dbname   string
// }

// // 2) 定义一个最简单的 Connection 结构体，用来模拟 mysql.Connection
// pub struct Connection {
// pub:
// 	host     string
// 	port     u32
// 	username string
// 	password string
// 	dbname   string
// }

// // 3) 定义一个最简单的函数 connect(config) -> Connection
// pub fn connect(cfg Config) !Connection {
// 	return Connection{
// 		host:     cfg.host
// 		port:     cfg.port
// 		username: cfg.username
// 		password: cfg.password
// 		dbname:   cfg.dbname
// 	}
// }

// // 4) 下面开始实现一个最简易的“连接池”

// struct DBPool {
// 	conns chan &Connection
// }

// // 一次性创建 size 个连接并将其放入 channel
// fn create_pool(size int, cfg Config) !&DBPool {
// 	mut conns := chan &Connection{cap: size}
// 	for _ in 0 .. size {
// 		conn := connect(cfg)!
// 		conns <- &conn
// 	}
// 	return &DBPool{
// 		conns: conns
// 	}
// }

// // 从池子里取出一个连接
// fn (pool &DBPool) get_conn() &Connection {
// 	return <-pool.conns
// }

// // 把用完的连接放回池子
// fn (pool &DBPool) release_conn(conn &Connection) {
// 	pool.conns <- conn
// }

// fn main() {
// 	// 配置数据库连接参数
// 	cfg := Config{
// 		host:     '127.0.0.1'
// 		port:     3306
// 		username: 'root'
// 		password: 'mysql_123456'
// 		dbname:   'test'
// 	}

// 	// 创建一个大小为 3 的连接池
// 	pool := create_pool(3, cfg) or { panic(err) }

// 	// 测试: 从池里拿一个连接
// 	conn := pool.get_conn()
// 	// println('Got a connection: ${conn}')
// 	dump(conn)

// 	// ...(此处执行查询或者更新操作)...

// 	// 添加错误上下文信息
// 	// 用毕归还
// 	pool.release_conn(conn)
// 	println('Connection returned to pool.')
// }

// @[table: 'sys_users']
// struct User {
// 	id       string
// 	nickname string
// }
