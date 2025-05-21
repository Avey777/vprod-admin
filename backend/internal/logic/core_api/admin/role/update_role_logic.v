module role

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Update Role ||更新Role
@['/update_role'; post]
fn (app &Role) update_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_role_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_role_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['Id'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	name := req.as_map()['Name'] or { '' }.str()
	code := req.as_map()['Code'] or { '' }.str()
	default_router := req.as_map()['DefaultRouter'] or { '' }.str()
	remark := req.as_map()['Remark'] or { '' }.str()
	sort := req.as_map()['Sort'] or { 1 }.u64()
	data_scope := req.as_map()['DataScope'] or { 1 }.u8()
	custom_dept_ids := req.as_map()['CustomDeptIds'] or { '' }.str()
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_role := orm.new_query[schema_sys.SysRole](db)

	sys_role.set('status = ?', status)!
		.set('name = ?', name)!
		.set('code = ?', code)!
		.set('default_router = ?', default_router)!
		.set('remark = ?', remark)!
		.set('sort = ?', sort)!
		.set('data_scope = ?', data_scope)!
		.set('custom_dept_ids = ?', custom_dept_ids)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
