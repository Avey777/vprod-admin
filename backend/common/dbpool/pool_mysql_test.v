module dbpool

import db.mysql

fn test_new_conn_pool_mysql() {
	mysql_conf := mysql.Config{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}
	mut pool := new_conn_pool_mysql(mysql_conf, 5) or {
		panic('Failed to create mysql pool: ${err}')
	}
	dump(typeof(pool).name)
	db := pool.acquire_mysql() or { panic(err) }
	assert typeof(db).name == 'mysql.DB'
	pool.release_mysql(db)
	pool.close_mysql()
	// Attemp to acquire after close should fail
	db_err := pool.acquire_mysql() or {
		dump('Correctly faild to acquire after close:${err}')
		return
	}
}
