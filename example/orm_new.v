module main

import db.sqlite
import time
import orm

@[table: 'sys_users']
struct User {
pub:
	id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
	name       string     @[immutable; sql: 'name'; sql_type: 'VARCHAR(255)'; unique]
	created_at time.Time  @[omitempty; sql_type: 'TIMESTAMP']
	updated_at ?time.Time @[default: new; omitempty; sql_type: 'TIMESTAMP']
}

fn main() {
	mut db := sqlite.connect(':memory:')!
	defer { db.close() or {} }

	user1 := User{
		id:         '001'
		name:       'Jengro'
		created_at: time.now()
		updated_at: time.now()
	}

	user2 := User{
		id:         '002'
		name:       'Dev'
		created_at: time.now()
		updated_at: time.now()
	}

	sql db {
		create table User
	} or { panic(err) }

	sql db {
		insert user1 into User
		insert user2 into User
	} or { panic(err) }

	// mut result := sql db {
	// 	select from User
	// } or { panic(err) }
	// dump(result)

	mut qb := orm.new_query[User](db)
	result1 := qb.select('id', 'name')!
		.query()!
	// qb.where('id != ?','000')!
	dump(result1)
}
