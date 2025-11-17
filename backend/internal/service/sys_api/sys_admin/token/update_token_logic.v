module token

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update Token ||更新Token
@['/update_token'; post]
fn (app &Token) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_token_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_token_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	id := req.as_map()['id'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	username := req.as_map()['username'] or { '' }.str()
	source := req.as_map()['source'] or { '' }.str()
	expired_at := req.as_map()['expired_at'] or { time.now() }.to_time()!
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	mut sys_token := orm.new_query[schema_sys.SysToken](db)

	sys_token.set('status = ?', status)!
		.set('username = ?', username)!
		.set('source = ?', source)!
		.set('expired_at = ?', expired_at)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
