module dbpool

import db.mysql

const config = mysql.Config{
	host:     '127.0.0.1'
	port:     3306
	username: 'root'
	password: 'mysql_123456'
	dbname:   'vcore'
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
