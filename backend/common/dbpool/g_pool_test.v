module dbpool

import db.mysql
// 使用示例

fn test_init_pool() {
	// 初始化配置
	config := mysql.Config{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}

	// 初始化连接池（5个连接）
	init_pool(config, 10) or { '' }

	// 获取连接
	mut conn := acquire()
	defer { release(conn) }

	// 执行查询
	rows := conn.exec('SELECT * FROM sys_users limit 1')!
	dump(rows)
}
