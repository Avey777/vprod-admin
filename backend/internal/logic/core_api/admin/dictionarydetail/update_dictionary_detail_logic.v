module dictionarydetail

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update dictionarydetail ||更新dictionarydetail
@['/update_dictionarydetail'; post]
fn (app &DictionaryDetail) update_dictionarydetail(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_dictionarydetail_resp(req) or {
		return ctx.json(json_error(503, '${err}'))
	}

	return ctx.json(json_success('success', result))
}

fn update_dictionarydetail_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['Id'] or { '' }.str()
	name := req.as_map()['Name'] or { '' }.str()
	title := req.as_map()['Title'] or { '' }.str()
	key := req.as_map()['Key'] or { '' }.str()
	value := req.as_map()['Value'] or { '' }.str()
	dictionary_id := req.as_map()['DictionaryId'] or { '' }.str()
	sort := req.as_map()['Sort'] or { 0 }.u32()
	status := req.as_map()['Status'] or { 0 }.u8()
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_dictionarydetail := orm.new_query[schema.SysDictionaryDetail](db)

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
