module user

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/update_user'; post]
fn (app &User) update_user_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateUserReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_user_resp(mut ctx Context, req UpdateUserReq) !UpdateUserResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut user_roles := []schema_core.CoreRoleTenantMember{cap: req.role_ids.len}
	for role_id in req.role_ids {
		user_roles << schema_core.CoreRoleTenantMember{
			member_id: req.user_id
			role_id:   role_id
		}
	}

	mut sys_user := orm.new_query[schema_core.CoreUser](db)
	mut user_role := orm.new_query[schema_core.CoreRoleTenantMember](db)

	sys_user.set('avatar = ?', req.avatar)!
		.set('email = ?', req.email)!
		.set('mobile = ?', req.mobile)!
		.set('nickname = ?', req.nickname)!
		.set('description = ?', req.description)!
		.set('home_path = ?', req.home_path)!
		.set('password = ?', req.password)!
		.set('status = ?', req.status)!
		.set('username = ?', req.username)!
		.set('updated_at = ?', req.updated_at)!
		.where('id = ?', req.user_id)!
		.update()!

	user_role.delete()!.where('user_id = ?', req.user_id)!
		.insert_many(user_roles)!

	return UpdateUserResp{
		msg: 'User updated successfully'
	}
}

struct UpdateUserReq {
	user_id     string    @[json: 'user_id']
	role_ids    []string  @[json: 'role_ids']
	avatar      string    @[json: 'avatar']
	description string    @[json: 'description']
	email       string    @[json: 'email']
	home_path   string    @[json: 'home_path']
	mobile      string    @[json: 'mobile']
	nickname    string    @[json: 'nickname']
	password    string    @[json: 'password']
	status      u8        @[default: 0; json: 'status']
	username    string    @[json: 'username']
	updated_at  time.Time @[json: 'updated_at']
}

struct UpdateUserResp {
	msg string @[json: 'msg']
}
