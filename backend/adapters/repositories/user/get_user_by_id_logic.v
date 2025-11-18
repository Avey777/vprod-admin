module user


import ports.sys_admin.user { UserRepository }
import structs.schema_sys { SysUser, SysRole }
import orm
import structs { Context }

pub struct UserRepoAdapter {
	dbpool &Context.dbpool
}

pub fn (r &UserRepoAdapter) find_by_id(user_id string) !SysUser {
	db, conn := r.dbpool.acquire() or { return error('Failed to acquire DB: ${err}') }
	defer { r.dbpool.release(conn) or {} }

	mut query := orm.new_query[SysUser](db)
	result := query.select()!.where('id = ?', user_id)!.query()!
	if result.len == 0 {
		return error('User not found')
	}

	return result[0]
}

pub fn (r &UserRepoAdapter) find_roles_by_user_id(user_id string) ![]SysRole {
	db, conn := r.dbpool.acquire() or { return error('Failed to acquire DB: ${err}') }
	defer { r.dbpool.release(conn) or {} }

	mut roles := []SysRole{}
	user_role_rows := sql db { select from schema_sys.SysUserRole where user_id == user_id }!
	for row in user_role_rows {
		role_rows := sql db { select from schema_sys.SysRole where id == row.role_id }!
		for r in role_rows {
			roles << SysRole{ id: r.id, name: r.name }
		}
	}
	return roles
}
