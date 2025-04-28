module dapartment

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Create dapartment | 创建dapartment
@['/create_dapartment'; post]
fn (app &Dapartment) create_dapartment(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_dapartment_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_dapartment_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	dapartments := schema.SysDepartment{
		id:         rand.uuid_v7()
		status:     req.as_map()['status'] or { 0 }.u8()
		name:       req.as_map()['Name'] or { '' }.str()
		ancestors:  req.as_map()['Ancestors'] or { '' }.str()
		leader:     req.as_map()['Leader'] or { '' }.str()
		sort:       req.as_map()['Sort'] or { 0 }.u64()
		phone:      req.as_map()['Phone'] or { '' }.str()
		remark:     req.as_map()['Remark'] or { '' }.str()
		parent_id:  req.as_map()['ParentId'] or { '' }.str()
		created_at: req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_dapartment := orm.new_query[schema.SysDepartment](db)
	sys_dapartment.insert(dapartments)!

	return map[string]Any{}
}
