module api

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Create api | 创建api
@['/create_api'; post]
fn (app &Api) create_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := create_api_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_api_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

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
