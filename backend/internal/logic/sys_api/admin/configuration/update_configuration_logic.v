module configuration

import veb
import log
import orm
import time
import x.json2
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update configuration ||更新configuration
@['/update_configuration'; post]
fn (app &Configuration) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.decode[json2.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_configuration_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_configuration_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	key := req.as_map()['key'] or { '' }.str()
	value := req.as_map()['value'] or { '' }.str()
	category := req.as_map()['category'] or { '' }.str()
	remark := req.as_map()['remark'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	sort := req.as_map()['sort'] or { 0 }.u64()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_configuration := orm.new_query[schema_sys.SysConfiguration](db)

	sys_configuration.set('name = ?', name)!
		.set('key = ?', key)!
		.set('value = ?', value)!
		.set('category = ?', category)!
		.set('remark = ?', remark)!
		.set('status = ?', status)!
		.set('sort = ?', sort)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
