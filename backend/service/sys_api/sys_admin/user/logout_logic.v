module user

import veb
import log
import orm
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

// Logout | 退出登入
@['/login_out'; post]
fn (app &User) logout_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[LogoutReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := logout_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn logout_resp(mut ctx Context, req LogoutReq) !LogoutResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.set('status = ?', '1')!.where('id = ?', req.user_id)!.update()!

	mut data := LogoutResp{
		logout: 'Logout successfull'
	}

	return data
}

struct LogoutReq {
	user_id string @[json: 'user_id']
}

struct LogoutResp {
	logout string @[json: 'logout']
}
