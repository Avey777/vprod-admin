module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Logout | 退出登入
@['/login_out'; post]
fn (app &User) logout_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := logout_resp(mut ctx, req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn logout_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() or {panic} }

	user_id := req.as_map()['id'] or { return error('Please return user_id') }.str()

	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.set('status = ?', '1')!.where('id = ?', user_id)!.update()!

	mut data := map[string]Any{}
	data['logout'] = 'Logout successfull'
	return data
}
