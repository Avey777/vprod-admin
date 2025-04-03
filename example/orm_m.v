module main

import db.mysql
import log
import time

fn main() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db := db_mysql() or { panic('failed to connect to database') }
	query_db(db)
	log.info('sys_users init Success')
}

@[table: 'sys_users']
struct User {
pub:
	id           string  @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
	created_at    ?time.Time @[omitempty; sql_type: 'TIMESTAMP' ]
	updated_at    ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
}

fn query_db(db mysql.DB) {
  mut query := sql db {
		select table User
	} or { panic(err) }
	dump(query)
}

fn db_mysql() !mysql.DB {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut mysql_config := mysql.Config{
		host:     '127.0.0.1'
		port:     3306
		username: 'root'
		password: 'mysql_123456'
		dbname:   'vcore'
	}

	log.debug('connecting db...')
	mut conn := mysql.connect(mysql_config) or {
		log.error('Mysql connect failed')
		return err
	}

	log.debug('${conn}')
	log.info('db connect success')
	return conn
}
