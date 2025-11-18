module repositories

import structs { Context }
import orm
import structs.schema_sys

// ----------------- 数据结构 -----------------
pub struct SysRole {
pub:
	id   string
	name string
}

// ----------------- 获取单个用户 -----------------
pub fn get_user_by_id(mut ctx Context, user_id string) !schema_sys.SysUser {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { println('Failed to release DB connection: ${err}') }
	}

	mut query := orm.new_query[schema_sys.SysUser](db)
	result := query.select()!.where('id = ?', user_id)!.query()!

	if result.len == 0 {
		return error('User not found')
	}

	return result[0]
}

// ----------------- 获取用户角色 -----------------
pub fn get_user_roles(mut ctx Context, user_id string) ![]SysRole {
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
		// 查询角色表获取角色名称
		mut role_rows := sql db {
			select from schema_sys.SysRole where id == row_urs.role_id
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
