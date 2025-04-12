module orm

// sql db {
//     // Define your database connection here
//     select from User where id == 0
// }

// mut db := sqlite.connect(':memory:')!
// defer {db.close() or{} }
// mut q := orm.new_query[Users](db)
// q.create()
// q.insert_many(users)
// mut read := q.query()
// dump(q)
// q.set('num=?',1).where('id=?','444').update()
// read= q.query()
// dump(read)

// count :=q.count()
// dump(count)

/*--------*/


// // # 动态条件：用户ID在子查询（预算为空或>100）
// mut query3 := orm db {
//     query[User] \
//     .where(User.budget_gt(100) | User.budget_is_null()) \
//     .as_subquery("rich_depts")
// }

// mut id_data := 007
// mut name_data := 'name1'

// mut query1 := orm db {
//     query[User]
//     .where('User.id=?'，id_data)
//     .where('User.name=?'，name_data)
//     .where('User.budget=?'，100) | ('User.budget=?',none)
//     .where('User.createdAt >= ?'，'2025-03-03 00:00:00') && ('User.createdAt <= ?','2025-03-05 23:59:59')
// }



// (a > ? AND b <= ?) OR (c <> ? AND (x = ? OR y = ?))
