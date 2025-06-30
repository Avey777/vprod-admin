module dbpool

import db.mysql

const config = mysql.Config{
	host:     'mysql2.sqlpub.com'
	port:     3307
	username: 'vcore_test'
	password: 'wfo8wS7CylT0qIMg'
	dbname:   'vcore_test'
}

fn test_new_conn_pool() {
	mut pool := new_conn_pool[mysql.DB](config, 5) or {
		panic('Failed to create mysql pool: ${err}')
	}
	dump(pool)
	db := pool.acquire() or { panic(err) }
	dump(db)
	data := db.exec('select 1')!
	dump(data)
	assert data[0] == mysql.Row{
		vals: ['1']
	}
	pool.release(db)
	pool.close()
}
