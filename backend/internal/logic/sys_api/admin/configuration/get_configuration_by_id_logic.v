module configuration

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

@['/id'; post]
fn (app &Configuration) configuration_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := configuration_by_id_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn configuration_by_id_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	configuration_id := req.as_map()['id'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut sys_configuration := orm.new_query[schema_sys.SysConfiguration](db)
	mut query := sys_configuration.select()!
	if configuration_id != '' {
		query = query.where('id = ?', configuration_id)!
	}
	result := query.query()!

	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['status'] = int(row.status)
		data['name'] = row.name
		data['key'] = row.key
		data['value'] = row.value
		data['category'] = row.category
		data['remark'] = row.remark or { '' }
		data['sort'] = int(row.sort)

		data['created_at'] = row.created_at.format_ss()
		data['updated_at'] = row.updated_at.format_ss()
		data['deleted_at'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
