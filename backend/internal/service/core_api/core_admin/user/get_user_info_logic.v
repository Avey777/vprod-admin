module user

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/info'; get]
fn (app &User) user_info(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[GetUserInfoReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := user_info_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn user_info_resp(mut ctx Context, req GetUserInfoReq) !GetUserInfoResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	// 查询特定用户信息
	mut core_user := orm.new_query[schema_core.CoreUser](db)
	users := core_user.select()!.where('id = ?', req.user_id)!.query()!

	if users.len == 0 {
		return error('User not found')
	}

	user := users[0]

	// 查询用户角色
	user_roles := sql db {
		select from schema_core.CoreRoleTenantMember where member_id == req.user_id
	}!

	mut user_role_ids := []string{}
	for user_role in user_roles {
		user_role_ids << user_role.role_id
	}

	// 查询角色名称
	mut user_role_names := []string{}
	if user_role_ids.len > 0 {
		roles := sql db {
			select from schema_core.CoreRole where id in user_role_ids
		}!
		for role in roles {
			user_role_names << role.name
		}
	}

	return GetUserInfoResp{
		user_id:    user.id
		username:   user.username
		nickname:   user.nickname
		avatar:     user.avatar or { '' }
		desc:       user.description or { '' }
		home_path:  user.home_path
		role_names: user_role_names
	}
}

struct GetUserInfoReq {
	user_id string @[json: 'user_id']
}

struct GetUserInfoResp {
	user_id    string   @[json: 'user_id']
	username   string   @[json: 'username']
	nickname   string   @[json: 'nickname']
	avatar     string   @[json: 'avatar']
	desc       string   @[json: 'desc']
	home_path  string   @[json: 'home_path']
	role_names []string @[json: 'role_names'] // 添加角色名称字段
}
