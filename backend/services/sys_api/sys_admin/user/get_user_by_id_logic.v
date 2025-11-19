module user

import veb
import log
import time
import x.json2 as json
import structs { Context }
import structs.schema_sys { SysUser }
import common.api
import orm

// ----------------- Handler 层 -----------------
@['/id'; post]
pub fn (app &User) find_user_by_id_handler(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UserByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	result := find_user_by_id_usecase(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

// ----------------- Application / Usecase 层 -----------------
pub fn find_user_by_id_usecase(mut ctx Context, req UserByIdReq) !UserByIdResp {
	// 调用 Domain 层逻辑
	user_data := user_by_id_domain(mut ctx, req.user_id)!

	// 调用 Repository 获取额外信息
	user_roles := find_user_roles_by_userid(mut ctx, req.user_id)!

	role_ids := user_roles.map(it.id)
	role_names := user_roles.map(fn (r SysRole) string {
		return r.name
	})

	data := UserById{
		id:         user_data.id
		username:   user_data.username
		nickname:   user_data.nickname
		status:     user_data.status
		role_ids:   role_ids
		role_names: role_names
		avatar:     user_data.avatar or { '' }
		desc:       user_data.description or { '' }
		home_path:  user_data.home_path
		mobile:     user_data.mobile or { '' }
		email:      user_data.email or { '' }
		creator_id: user_data.creator_id or { '' }
		updater_id: user_data.updater_id or { '' }
		created_at: user_data.created_at.format_ss()
		updated_at: user_data.updated_at.format_ss()
		deleted_at: (user_data.deleted_at or { time.Time{} }).format_ss()
	}

	return UserByIdResp{
		datalist: [data]
	}
}

// ----------------- Domain 层 -----------------
fn user_by_id_domain(mut ctx Context, user_id string) !SysUser {
	// 核心业务逻辑，例如参数校验、权限检查等
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	// 调用 Repository 获取用户数据
	return find_user_by_id(mut ctx, user_id)!
}

// ----------------- DTO 层 | 请求/返回结构 -----------------
pub struct UserByIdReq {
	user_id string
}

pub struct UserByIdResp {
	datalist []UserById
}

pub struct UserById {
	id         string
	username   string
	nickname   string
	status     u8
	role_ids   []string
	role_names []string
	avatar     string
	desc       string
	home_path  string
	mobile     string
	email      string
	creator_id string
	updater_id string
	created_at string
	updated_at string
	deleted_at string
}

// ----------------- AdapterRepository 层 -----------------
struct SysRole {
	id   string
	name string
}

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
