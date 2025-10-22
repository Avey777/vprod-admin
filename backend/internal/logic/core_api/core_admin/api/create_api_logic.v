module api

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Create api | 创建api
@['/create_api'; post]
fn (app &Api) create_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateCoreApiReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_api_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_api_resp(mut ctx Context, req CreateCoreApiReq) !string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	time_now := time.now()
	apis := schema_core.CoreApi{
		id:           rand.uuid_v7()
		path:         req.path // or { return error('path is required') }
		description:  req.description or { '' }
		api_group:    req.api_group    // or { return error('api_group is required') }.str()
		service_name: req.service_name // or { return error('service_name is required') }.str()
		method:       req.method       // or { return error('method is required') }.str()
		is_required:  req.is_required  // or { 0 }.u8()
		source_type:  req.source_type  // or { return error('source_type is required') }.str()
		source_id:    req.source_id    // or { return error('source_id is required') }.str()
		created_at:   req.created_at or { time_now }   //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:   req.updated_at or { time_now }
	}

	mut sys_api := orm.new_query[schema_core.CoreApi](db)
	sys_api.insert(apis)!

	return 'API created successfully'
}

struct CreateCoreApiReq {
	id           string     @[json: 'id'; required]
	path         string     @[json: 'path'; required]
	description  ?string    @[json: 'description']
	api_group    string     @[json: 'api_group'; required]
	service_name string     @[json: 'service_name'; required]
	method       string     @[json: 'method'; required]
	is_required  u8         @[default: 0; json: 'is_required'; required]
	source_type  string     @[json: 'source_type'; required]
	source_id    string     @[json: 'source_id'; required]
	created_at   ?time.Time @[json: 'created_at']
	updated_at   ?time.Time @[json: 'updated_at']
}
