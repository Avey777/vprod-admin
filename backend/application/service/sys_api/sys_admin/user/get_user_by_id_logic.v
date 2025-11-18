module user

import veb
import log
import time
import x.json2 as json
import structs { Context }
import structs.schema_sys { SysUser }
import adapters.repositories as repo
import common.api

// ----------------- Handler 层 -----------------
@['/id_ddd'; post]
pub fn (app &User) user_by_id_handler(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UserByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	result := user_by_id_usecase(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

// ----------------- Application / Usecase 层 -----------------
fn user_by_id_usecase(mut ctx Context, req UserByIdReq) !UserByIdResp {
	// 调用 Domain 层逻辑
	user_data := user_by_id_domain(mut ctx, req.user_id)!

	// 调用 Repository 获取额外信息
	user_roles := repo.get_user_roles(mut ctx, req.user_id)!

	role_ids := user_roles.map(it.id)
	role_names := user_roles.map(fn (r repo.SysRole) string {
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
	return repo.get_user_by_id(mut ctx, user_id)!
}

// ----------------- 请求/返回结构 -----------------
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
