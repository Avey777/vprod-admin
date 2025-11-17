module department

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Create department | 创建department
@['/create_department'; post]
fn (app &Department) create_department(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := create_department_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_department_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	departments := schema_sys.SysDepartment{
		id:        rand.uuid_v7()
		parent_id: req.as_map()['parent_id'] or { '00000000-0000-0000-0000-000000000000' }.str()
		status:    req.as_map()['status'] or { 0 }.u8()
		name:      req.as_map()['name'] or { '' }.str()
		leader:    req.as_map()['leader'] or { '' }.str()
		sort:      req.as_map()['sort'] or { 0 }.u32()
		phone:     req.as_map()['phone'] or { '' }.str()
		remark:    req.as_map()['remark'] or { '' }.str()

		created_at: req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_department := orm.new_query[schema_sys.SysDepartment](db)
	sys_department.insert(departments)!

	return map[string]Any{}
}
