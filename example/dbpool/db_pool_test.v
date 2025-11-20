module dbpool

fn test_new_db_pool() {
	conf := DatabaseConfig{
		db_type:  'mysql' // 或 'pgsql'
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}

	mut pool := new_db_pool(conf) or { panic(err) }

	mut db, handler := pool.acquire() or { panic(err) }

	// query 测试
	rows := db.query('SELECT 1') or { panic(err) }
	assert rows.len > 0

	// 释放连接
	pool.release(handler)!

	// 关闭连接池
	pool.close()
}
