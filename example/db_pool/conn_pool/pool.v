// module main

// import db.mysql
// import pool
// import time
// import veb

// // 数据库连接配置
// struct DbConfig {
// 	host           string
// 	port           u32
// 	username       string
// 	password       string
// 	dbname         string
// 	max_conns      int           = 10
// 	min_idle_conns int           = 2
// 	max_lifetime   time.Duration = 1 * time.hour
// 	idle_timeout   time.Duration = 30 * time.minute
// 	get_timeout    time.Duration = 5 * time.second
// }

// // 连接池结构体
// @[heap]
// struct DBPool {
// mut:
// 	inner &pool.ConnectionPool
// }

// // 创建新连接池
// fn new_db_pool(config DbConfig) !&DBPool {
// 	create_conn := fn [config] () !&pool.ConnectionPoolable {
// 		mut db := mysql.connect(mysql.Config{
// 			host:     config.host
// 			port:     config.port
// 			username: config.username
// 			password: config.password
// 			dbname:   config.dbname
// 		})!
// 		return &db
// 	}

// 	pool_conf := pool.ConnectionPoolConfig{
// 		max_conns:      config.max_conns
// 		min_idle_conns: config.min_idle_conns
// 		max_lifetime:   config.max_lifetime
// 		idle_timeout:   config.idle_timeout
// 		get_timeout:    config.get_timeout
// 	}

// 	inner_pool := pool.new_connection_pool(create_conn, pool_conf)!
// 	return &DBPool{
// 		inner: inner_pool
// 	}
// }

// // 获取连接
// fn (mut p DBPool) acquire() !(mysql.DB, &pool.ConnectionPoolable) {
// 	conn := p.inner.get()!
// 	return conn as mysql.DB, conn
// }

// // 释放连接
// fn (mut p DBPool) release(conn &pool.ConnectionPoolable) ! {
// 	p.inner.put(conn)!
// }

// // 关闭连接池
// fn (mut p DBPool) close() {
// 	p.inner.close()
// }

// // 添加上下文中的连接池
// struct Context {
// 	veb.Context
// pub mut:
// 	db_pool &DBPool
// }

// struct App {
// 	veb.Middleware[Context]
// }

// fn init_pool() !&DBPool {
// 	config := DbConfig{
// 		host:     'mysql2.sqlpub.com'
// 		port:     3307
// 		username: 'vcore_test'
// 		password: 'wfo8wS7CylT0qIMg'
// 		dbname:   'vcore_test'
// 	}
// 	return new_db_pool(config) or {
// 		eprint('连接池创建失败: ${err}')
// 		return err
// 	}
// }

// fn main() {
// 	mut db_pool := init_pool() or {
// 		eprintln('初始化失败: ${err}')
// 		return
// 	}
// 	defer {
// 		db_pool.close()
// 	}

// 	mut app := &App{}
// 	// 中间件：将 db_pool 注入到每个请求的 Context
// 	app.use(veb.MiddlewareOptions[Context]{
// 		handler: fn [db_pool] (mut ctx Context) bool {
// 			ctx.db_pool = db_pool
// 			return true
// 		}
// 	})

// 	veb.run[App, Context](mut app, 9008)
// }

// @['/index']
// fn (mut app App) get_user(mut ctx Context) veb.Result {
// 	// 使用上下文中的连接池
// 	mut db, conn := ctx.db_pool.acquire() or { return ctx.text('获取连接失败: ${err}') }

// 	defer {
// 		ctx.db_pool.release(conn) or { eprintln('释放连接失败: ${err}') }
// 	}

// 	query := 'SELECT * FROM sys_users WHERE id = 1'
// 	rows := db.exec(query) or { return ctx.text('查询失败: ${err}') }

// 	return ctx.text(rows.str())
// }
