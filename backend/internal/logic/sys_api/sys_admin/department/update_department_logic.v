module department

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Update department ||更新department
@['/update_department'; post]
fn (app &Department) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_department_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_department_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	leader := req.as_map()['leader'] or { '' }.str()
	phone := req.as_map()['phone'] or { '' }.str()
	email := req.as_map()['email'] or { '' }.str()
	remark := req.as_map()['remark'] or { '' }.str()
	parent_id := req.as_map()['parent_id'] or { '00000000-0000-0000-0000-000000000000' }.str()
	status := req.as_map()['status'] or { 0 }.u8()
	sort := req.as_map()['sort'] or { 0 }.u64()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_department := orm.new_query[schema_sys.SysDepartment](db)

	sys_department.set('parent_id = ?', parent_id)!
		.set('name = ?', name)!
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
