module dbpool

import db.mysql

fn test_new_conn_pool() {
	mut pool := new_conn_pool('mysql') or { panic('Failed to create mysql pool: ${err}') }
	db, _ := pool.acquire() or { panic(err) }
	data := db.exec('select 1') or { panic(err) }
	dump(data)
	assert data[0] == mysql.Row{
		vals: ['1']
	}

	pool.release(db)
	pool.close()
}
