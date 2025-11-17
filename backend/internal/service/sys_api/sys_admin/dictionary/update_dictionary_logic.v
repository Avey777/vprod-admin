module dictionary

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update dictionary ||更新dictionary
@['/update_dictionary'; post]
fn (app &Dictionary) update_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_dictionary_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_dictionary_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	title := req.as_map()['title'] or { '' }.str()
	desc := req.as_map()['desc'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_dictionary := orm.new_query[schema_sys.SysDictionary](db)

	sys_dictionary.set('name = ?', name)!
		.set('title = ?', title)!
		.set('desc = ?', desc)!
		.set('status = ?', status)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
