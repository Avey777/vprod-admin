module dbpool

import db.pg

fn test_new_conn_pool_pg() {
	pg_conf := pg.Config{
		host:     'localhost'
		port:     5432
		user:     'postgres'
		password: '123456'
		dbname:   'redash'
	}

	mut pool := new_conn_pool_pg(pg_conf, 5) or { panic('Failed to create pg pool: ${err}') }

	db := pool.acquire_pg() or { panic(err) }
	assert typeof(db).name == 'pg.DB'
	pool.release_pg(db)
	pool.close_pg()
	// Attemp to acquire after close should fail
	db_err := pool.acquire_pg() or {
		dump('Correctly faild to acquire after close:${err}')
		return
	}
}
