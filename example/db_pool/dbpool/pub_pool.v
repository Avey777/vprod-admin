// vtest build: !(macos || windows)
import db.mysql
import pool
import time

// Define your connection factory function
fn create_conn() !&pool.ConnectionPoolable {
	config := mysql.Config{
		host:     'mysql2.sqlpub.com'
		port:     3307
		username: 'vcore_test'
		password: 'wfo8wS7CylT0qIMg'
		dbname:   'vcore_test'
	}
	db := mysql.connect(config)!
	return &db
}

fn main() {
	// Configure pool parameters
	config := pool.ConnectionPoolConfig{
		max_conns:      50
		min_idle_conns: 5
		max_lifetime:   2 * time.hour
		idle_timeout:   30 * time.minute
		get_timeout:    5 * time.second
	}

	// Create connection pool
	mut db_pool := pool.new_connection_pool(create_conn, config)!
	dump(db_pool)
	defer {
		// When application exits
		db_pool.close()
	}

	// Acquire connection
	mut conn := db_pool.get()!
	dump(conn)
	defer {
		db_pool.put(conn) or { println(err) } // Return connection to pool
	}

	// Convert `conn` to a `mysql.DB` object
	mut db := conn as mysql.DB
	dump(db)

	assert db.validate()!
}
