module position

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update position ||更新position
@['/update_position'; post]
fn (app &Position) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_position_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_position_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['Id'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	name := req.as_map()['Name'] or { '' }.str()
	code := req.as_map()['Code'] or { '' }.str()
	remark := req.as_map()['Remark'] or { '' }.str()
	sort := req.as_map()['Sort'] or { 1 }.u64()
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_position := orm.new_query[schema.SysPosition](db)

	sys_position.set('status = ?', status)!
		.set('name = ?', name)!
		.set('code = ?', code)!
		.set('remark = ?', remark)!
		.set('sort = ?', sort)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
