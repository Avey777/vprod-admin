module dbpool

import db.mysql
import db.pg

pub struct ConnectionPool {
	type string
mut:
	connections_mysql chan mysql.DB
	config_mysql      mysql.Config
	connections_pg    chan pg.DB
	config_pg         pg.Config
}
