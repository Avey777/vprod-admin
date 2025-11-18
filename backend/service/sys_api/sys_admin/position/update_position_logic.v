module position

import veb
import log
import orm
import time
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

// Update position ||更新position
@['/update_position'; post]
fn (app &Position) update_position(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_position_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_position_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	name := req.as_map()['name'] or { '' }.str()
	code := req.as_map()['code'] or { '' }.str()
	remark := req.as_map()['remark'] or { '' }.str()
	sort := req.as_map()['sort'] or { 1 }.u64()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_position := orm.new_query[schema_sys.SysPosition](db)

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
