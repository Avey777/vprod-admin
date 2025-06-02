module role

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
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
	defer { db.close() }

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
		data['Status'] = int(row.status)
		data['Name'] = row.name
		data['Code'] = row.code
		data['DefaultRouter'] = row.default_router
		data['Remark'] = row.remark or { '' }
		data['Sort'] = int(row.sort)
		data['DataScope'] = int(row.data_scope)
		data['CustomDeptIds'] = row.custom_dept_ids or { '' }
		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
