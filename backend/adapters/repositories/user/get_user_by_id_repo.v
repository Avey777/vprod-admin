// ===========================
// module: adapters.repositories.user
// ===========================
module user

import structs { Context }
import structs.schema_sys { SysRole, SysUser, SysUserRole }
import orm
import parts.sys_admin.user { SysRolePart, SysUserPart }

pub struct UserRepo {
pub mut:
	ctx &Context
}

pub fn (mut r UserRepo) find_user_by_id_repo(user_id string) !SysUserPart {
	db, conn := r.ctx.dbpool.acquire() or {
		return error('Failed to acquire DB connection: ${err}')
	}
	defer {
		r.ctx.dbpool.release(conn) or { println('Failed to release DB connection: ${err}') }
	}

	mut query := orm.new_query[SysUser](db)
	result := query.select()!.where('id = ?', user_id)!.query()!

	if result.len == 0 {
		return error('User not found')
	}

	user_info := result[0]
	return SysUserPart{
		id:          user_info.id
		username:    user_info.username
		nickname:    user_info.nickname
		status:      user_info.status
		avatar:      user_info.avatar
		description: user_info.description
		home_path:   user_info.home_path
		mobile:      user_info.mobile
		email:       user_info.email
		creator_id:  user_info.creator_id
		updater_id:  user_info.updater_id
		created_at:  user_info.created_at
		updated_at:  user_info.updated_at
		deleted_at:  user_info.deleted_at
	}
}

pub fn (mut r UserRepo) find_roles_by_user_id_repo(user_id string) ![]SysRolePart {
	db, conn := r.ctx.dbpool.acquire() or {
		return error('Failed to acquire DB connection: ${err}')
	}
	defer {
		r.ctx.dbpool.release(conn) or { println('Failed to release DB connection: ${err}') }
	}

	user_role_rows := sql db {
		select from SysUserRole where user_id == user_id
	}!

	if user_role_rows.len == 0 {
		return []
	}

	role_ids := user_role_rows.map(it.role_id)

	role_rows := sql db {
		select from SysRole where id in role_ids
	}!

	roles := role_rows.map(fn (r SysRole) SysRolePart {
		return SysRolePart{
			id:   r.id
			name: r.name
		}
	})

	return roles
}
