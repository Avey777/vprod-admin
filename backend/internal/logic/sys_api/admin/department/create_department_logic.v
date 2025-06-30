module department

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Create department | 创建department
@['/create_department'; post]
fn (app &Department) create_department(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_department_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_department_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() or {panic} }

	departments := schema_sys.SysDepartment{
		id:         rand.uuid_v7()
		status:     req.as_map()['status'] or { 0 }.u8()
		name:       req.as_map()['name'] or { '' }.str()
		ancestors:  req.as_map()['ancestors'] or { '' }.str()
		leader:     req.as_map()['leader'] or { '' }.str()
		sort:       req.as_map()['sort'] or { 0 }.u32()
		phone:      req.as_map()['phone'] or { '' }.str()
		remark:     req.as_map()['remark'] or { '' }.str()
		parent_id:  req.as_map()['parent_id'] or { '' }.str()
		created_at: req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_department := orm.new_query[schema_sys.SysDepartment](db)
	sys_department.insert(departments)!

	return map[string]Any{}
}
