module api

import veb
import log
import orm
import time
import x.json2 as json
import structs.schema_core
import common.api
import structs { Context }

// Update api ||更新api
@['/update_api'; post]
fn (app &Api) update_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateCoreApiReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_api_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_api_resp(mut ctx Context, req UpdateCoreApiReq) !UpdateCoreApiResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreApi](db)

	sys_api.set('path = ?', req.path)!
		.set('description = ?', req.description or { '' })!
		.set('api_group = ?', req.api_group)!
		.set('service_name = ?', req.service_name)!
		.set('method = ?', req.method)!
		.set('is_required = ?', req.is_required)!
		.set('source_type = ?', req.source_type)!
		.set('source_id = ?', req.source_id)!
		.set('updated_at = ?', time.now())!
		.where('id = ?', req.id)!
		.update()!

	return UpdateCoreApiResp{
		msg: 'API updated successfully'
	}
}

struct UpdateCoreApiReq {
	id           string     @[json: 'id'; required]
	path         string     @[json: 'path'; required]
	description  ?string    @[json: 'description']
	api_group    string     @[json: 'api_group'; required]
	service_name string     @[json: 'service_name'; required]
	method       string     @[json: 'method'; required]
	is_required  u8         @[default: 0; json: 'is_required'; required]
	source_type  string     @[json: 'source_type'; required]
	source_id    string     @[json: 'source_id'; required]
	updated_at   ?time.Time @[json: 'updated_at']
}

struct UpdateCoreApiResp {
	msg string
}
