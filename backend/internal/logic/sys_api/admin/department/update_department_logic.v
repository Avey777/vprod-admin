module department

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Update department ||更新department
@['/update_department'; post]
fn (app &Department) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_department_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success(200,'success', result))
}

fn update_department_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	ancestors := req.as_map()['ancestors'] or { '' }.str()
	leader := req.as_map()['leader'] or { '' }.str()
	phone := req.as_map()['phone'] or { '' }.str()
	email := req.as_map()['email'] or { '' }.str()
	remark := req.as_map()['remark'] or { '' }.str()
	parent_id := req.as_map()['parent_id'] or { '' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	sort := req.as_map()['sort'] or { 0 }.u64()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() or {panic} }

	mut sys_department := orm.new_query[schema_sys.SysDepartment](db)

	sys_department.set('parent_id = ?', parent_id)!
		.set('name = ?', name)!
		.set('ancestors = ?', ancestors)!
		.set('leader = ?', leader)!
		.set('phone = ?', phone)!
		.set('email = ?', email)!
		.set('remark = ?', remark)!
		.set('status = ?', status)!
		.set('sort = ?', sort)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
