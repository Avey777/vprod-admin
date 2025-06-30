module role

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
fn (app &Role) role_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := role_by_id_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn role_by_id_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	role_id := req.as_map()['id'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() or {panic} }

	mut sys_role := orm.new_query[schema_sys.SysRole](db)
	mut query := sys_role.select()!
	if role_id != '' {
		query = query.where('id = ?', role_id)!
	}
	result := query.query()!

	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['status'] = int(row.status)
		data['name'] = row.name
		data['code'] = row.code
		data['default_router'] = row.default_router
		data['remark'] = row.remark or { '' }
		data['sort'] = int(row.sort)
		data['data_scope'] = int(row.data_scope)
		data['custom_dept_ids'] = row.custom_dept_ids or { '' }
		data['created_at'] = row.created_at.format_ss()
		data['updated_at'] = row.updated_at.format_ss()
		data['deleted_at'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
