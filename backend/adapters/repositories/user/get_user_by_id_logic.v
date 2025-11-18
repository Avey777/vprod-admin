module user

import structs { Context }
import structs.schema_sys { SysRole, SysUser }
import orm

// 获取单个用户
pub fn find_user_by_id(mut ctx Context, user_id string) !SysUser {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { println('Failed to release DB connection: ${err}') }
	}

	mut query := orm.new_query[SysUser](db)
	result := query.select()!.where('id = ?', user_id)!.query()!

	if result.len == 0 {
		return error('User not found')
	}

	return result[0]
}

// 获取用户角色
pub fn find_user_roles_by_userid(mut ctx Context, user_id string) ![]SysRole {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { println('Failed to release DB connection: ${err}') }
	}

	// 查询用户角色表
	mut user_role_rows := sql db {
		select from schema_sys.SysUserRole where user_id == user_id
	}!

	mut roles := []SysRole{}

	for row_urs in user_role_rows {
		mut role_rows := sql db {
			select from SysRole where id == row_urs.role_id
		}!
		for r in role_rows {
			roles << SysRole{
				id:   r.id
				name: r.name
			}
		}
	}

	return roles
}
