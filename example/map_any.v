// module main

// type Any = string | int | f64 | bool | []map[string]Any

// fn main() {
// 	// 创建 map[string]any 的切片
// 	mut data_list := []map[string]Any{}

// 	mut item := map[string]Any{}
// 	item['name'] = 'name'
// 	item['age'] = 1
// 	data_list << item
// 	dump(data_list)

// 	mut result := map[string]Any{}
// 	result['account'] = 123
// 	result['data'] = data_list

// 	dump(result)
// }

module main

import db.sqlite
import time
import json

@[table: 'sys_users']
struct Users {
	id         string     @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(255)'; unique]
	name       ?string    @[immutable; sql: 'name'; sql_type: 'VARCHAR(255)'; unique]
	created_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
	updated_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP']
}

type Any = string | int | []string | []int | bool | []map[string]Any | time.Time

fn main() {
	mut db := sqlite.connect(':memory:')!
	defer { db.close() or {} }

	sql db {
		create table Users
	}!
	user1 := Users{
		id:         '123'
		name:       'name1'
		created_at: time.now()
		// updated_at defaults to none
	}
	user2 := Users{
		id: 'abc'
		// name:       'name2'
		created_at: time.now()
		updated_at: time.now()
	}

	sql db {
		insert user1 into Users
		insert user2 into Users
	}!

	data_all := sql db {
		select from Users
	}!
	// dump(data_all)

	mut result := []map[string]Any{}
	for raw in data_all {
		mut data := map[string]Any{}
		data['id'] = raw.id
		data['name'] = raw.name or { '' }
		data['updatedAt'] = raw.updated_at or { time.Time{} }.format_ss()
		result << data
	}
	// dump(result)
	dump(json.encode(result))
}
