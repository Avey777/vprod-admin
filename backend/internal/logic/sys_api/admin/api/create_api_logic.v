module api

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
	defer { db.close() or {panic} }

	apis := schema_sys.SysApi{
		id:           rand.uuid_v7()
		path:         req.as_map()['path'] or { '' }.str()
		description:  req.as_map()['description'] or { '' }.str()
		api_group:    req.as_map()['api_group'] or { '' }.str()
		service_name: req.as_map()['service_name'] or { 0 }.str()
		method:       req.as_map()['method'] or { '' }.str()
		is_required:  req.as_map()['is_required'] or { '' }.u8()
		created_at:   req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:   req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_api := orm.new_query[schema_sys.SysApi](db)
	sys_api.insert(apis)!

	return map[string]Any{}
}
