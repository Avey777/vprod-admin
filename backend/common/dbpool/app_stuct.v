module dbpool

import db.mysql

pub struct ConnectionPool {
mut:
	connections chan mysql.DB
	config      mysql.Config
}
