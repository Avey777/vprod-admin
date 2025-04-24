module token

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update Token ||更新Token
@['/update_token'; post]
fn (app &Token) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_token_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_token_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	username := req.as_map()['username'] or { '' }.str()
	source := req.as_map()['Source'] or { '' }.str()
	expired_at := req.as_map()['expiredAt'] or { time.now() }.to_time()!
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_token := orm.new_query[schema.SysToken](db)

	sys_token.set('status = ?', status)!
		.set('username = ?', username)!
		.set('source = ?', source)!
		.set('expired_at = ?', expired_at)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', user_id)!
		.update()!

	return map[string]Any{}
}
