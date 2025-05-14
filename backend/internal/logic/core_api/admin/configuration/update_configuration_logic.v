module configuration

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_success, json_error }
import internal.structs { Context }

// Update configuration ||更新configuration
@['/update_configuration'; post]
fn (app &Configuration) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_configuration_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_configuration_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['Id'] or { '' }.str()
	name := req.as_map()['Name'] or { '' }.str()
	key := req.as_map()['Key'] or { '' }.str()
	value := req.as_map()['Value'] or { '' }.str()
	category := req.as_map()['Category'] or { '' }.str()
	remark := req.as_map()['Remark'] or { '' }.str()
	status := req.as_map()['Status'] or { 0 }.u8()
	sort := req.as_map()['Sort'] or { 0 }.u64()
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_configuration := orm.new_query[schema.SysConfiguration](db)

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
