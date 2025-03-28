module main

import db.mysql
import log

fn main() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db := db_mysql() or { panic('failed to connect to database') }
	create_db(db)
	// sql db {
	// 	create table User
	// } or { panic(err) }
	log.info('sys_users init Success')
}

@[table: 'sys_users']
struct User {
pub:
	id        string  @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
	home_path ?string @[default: 'dashboard'; omitempty; sql_type: 'VARCHAR(64)'] // success
	// home_path ?string @[default: '0212654'; omitempty; sql_type: 'VARCHAR(64)']  //failed
}

fn create_db(db mysql.DB) {
	sql db {
		create table User
	} or { panic(err) }
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
