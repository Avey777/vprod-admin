module dictionary

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Update dictionary ||更新dictionary
@['/update_dictionary'; post]
fn (app &Dictionary) update_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_dictionary_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_dictionary_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	title := req.as_map()['title'] or { '' }.str()
	desc := req.as_map()['desc'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() or {panic} }

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
