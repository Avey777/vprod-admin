// ===========================
// module: adapters.repositories.user
// ===========================
/*
repo（仓储）
依赖 parts（返回 Part 类型很合理）
不依赖 domain（保持干净）
不依赖 dto（推荐不要依赖） :DTO 是 API 的表层结构，Repo 永远不应该知道它。
*/
module user

import orm
import structs { Context }
import structs.schema_sys { SysRole, SysUser, SysUserRole }
import parts.sys_admin.user { SysRolePart, SysUserPart }

// ---- 轻量 mapper（最小侵入版本） ----
fn to_user_part(entity SysUser) SysUserPart {
	return SysUserPart{
		id:          entity.id
		username:    entity.username
		nickname:    entity.nickname
		status:      entity.status
		avatar:      entity.avatar
		description: entity.description
		home_path:   entity.home_path
		mobile:      entity.mobile
		email:       entity.email
		creator_id:  entity.creator_id
		updater_id:  entity.updater_id
		created_at:  entity.created_at
		updated_at:  entity.updated_at
		deleted_at:  entity.deleted_at
	}
}

fn to_role_part(entity SysRole) SysRolePart {
	return SysRolePart{
		id:   entity.id
		name: entity.name
	}
}

// Repository 层
pub struct UserRepo {
pub mut:
	ctx &Context
}

pub fn (mut r UserRepo) find_user_by_id(user_id string) !SysUserPart {
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

	// 使用 mapper
	return to_user_part(result[0])
}

pub fn (mut r UserRepo) find_roles_by_user_id(user_id string) ![]SysRolePart {
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

	return role_rows.map(to_role_part)
}
