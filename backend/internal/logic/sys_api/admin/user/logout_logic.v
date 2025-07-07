module user

import veb
import log
import orm
import x.json2

import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Logout | 退出登入
@['/login_out'; post]
fn (app &User) logout_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := logout_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg()) ) }

	return ctx.json(api.json_success_200(result) )
}

fn logout_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	user_id := req.as_map()['id'] or { return error('Please return user_id') }.str()

	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.set('status = ?', '1')!.where('id = ?', user_id)!.update()!

	mut data := map[string]Any{}
	data['logout'] = 'Logout successfull'
	return data
}
