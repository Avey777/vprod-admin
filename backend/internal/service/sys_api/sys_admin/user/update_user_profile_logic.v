module user

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update User Profile ||更新用户资料
@['/update_user_profile'; post]
fn (app &User) update_user_profile_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateUserProfileReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_user_profile_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_user_profile_resp(mut ctx Context, req UpdateUserProfileReq) !UpdateUserProfileResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)

	sys_user.set('avatar = ?', req.avatar)!
		.set('email = ?', req.email)!
		.set('mobile = ?', req.mobile)!
		.set('nickname = ?', req.nickname)!
		.where('id = ?', req.user_id)!
		.update()!

	return UpdateUserProfileResp{
		msg: 'User profile updated successfully'
	}
}

struct UpdateUserProfileReq {
	user_id  string @[json: 'user_id']
	avatar   string @[json: 'avatar']
	email    string @[json: 'email']
	mobile   string @[json: 'mobile']
	nickname string @[json: 'nickname']
}

struct UpdateUserProfileResp {
	msg string @[json: 'msg']
}
