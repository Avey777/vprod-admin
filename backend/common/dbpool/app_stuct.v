module dbpool

import db.mysql

pub struct ConnectionPool {
pub mut:
	connections chan mysql.DB
	config      mysql.Config
}
