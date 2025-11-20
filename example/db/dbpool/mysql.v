module main

import db.mysql

// ======================================
// MySQL Adapter
// ======================================
pub struct MysqlAdapter {
mut:
	conn mysql.DB
}

pub fn new_mysql_adapter(conf DatabaseConfig) !&MysqlAdapter {
	db := mysql.connect(mysql.Config{
		host:     conf.host
		port:     conf.port
		username: conf.username
		password: conf.password
		dbname:   conf.dbname
	})!
	return &MysqlAdapter{db}
}

pub fn (mut a MysqlAdapter) query(q string) ![]map[string]string {
	return a.conn.query(q)!.maps()
}

pub fn (mut a MysqlAdapter) execute(q string) !int {
	return a.conn.exec_none(q)
}

// ConnectionPoolable
pub fn (mut a MysqlAdapter) validate() !bool {
	a.conn.ping()!
	return true
}

pub fn (mut a MysqlAdapter) reset() ! {}

pub fn (mut a MysqlAdapter) close() ! {
	a.conn.close()!
}
