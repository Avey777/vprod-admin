module api

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Create api | 创建api
@['/create_api'; post]
fn (app &Api) create_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_api_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_api_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	apis := schema.SysApi{
		id:           rand.uuid_v7()
		path:         req.as_map()['Path'] or { '' }.str()
		description:  req.as_map()['Description'] or { '' }.str()
		api_group:    req.as_map()['Group'] or { '' }.str()
		service_name: req.as_map()['ServiceName'] or { 0 }.str()
		method:       req.as_map()['Method'] or { '' }.str()
		is_required:  req.as_map()['IsRequired'] or { '' }.u8()
		created_at:   req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:   req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_api := orm.new_query[schema.SysApi](db)
	sys_api.insert(apis)!

	return map[string]Any{}
}
