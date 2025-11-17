module dictionarydetail

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update dictionarydetail ||更新dictionarydetail
@['/update_dictionarydetail'; post]
fn (app &DictionaryDetail) update_dictionarydetail(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_dictionarydetail_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_dictionarydetail_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	title := req.as_map()['title'] or { '' }.str()
	key := req.as_map()['key'] or { '' }.str()
	value := req.as_map()['value'] or { '' }.str()
	dictionary_id := req.as_map()['dictionary_id'] or { '' }.str()
	sort := req.as_map()['sort'] or { 0 }.u32()
	status := req.as_map()['status'] or { 0 }.u8()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_dictionarydetail := orm.new_query[schema_sys.SysDictionaryDetail](db)

	sys_dictionarydetail.set('title = ?', title)!
		.set('name = ?', name)!
		.set('key = ?', key)!
		.set('value = ?', value)!
		.set('sort = ?', sort)!
		.set('status = ?', status)!
		.set('dictionary_id = ?', dictionary_id)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
