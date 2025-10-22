module api

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/id'; post]
fn (app &Api) api_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetCoreApiByIDReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := api_by_id_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn api_by_id_resp(mut ctx Context, req GetCoreApiByIDReq) ![]GetCoreApiByIDResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreApi](db)
	mut query := sys_api.select()!
	if req.id != '' {
		query = query.where('id = ?', req.id)!.limit(1)!
	}
	result := query.query()!
	if result.len == 0 {
		return error('API not found')
	}

	mut datalist := []GetCoreApiByIDResp{} // map空数组初始化
	for row in result {
		resp_obj := GetCoreApiByIDResp{
			id:           row.id
			path:         row.path
			description:  row.description
			api_group:    row.api_group
			service_name: row.service_name
			method:       row.method
			is_required:  row.is_required
			source_type:  row.source_type
			source_id:    row.source_id
			created_at:   row.created_at
			updated_at:   row.updated_at
			deleted_at:   row.deleted_at or { time.Time{} }
		}

		datalist << resp_obj //追加resp_obj到maplist 数组
	}

	return datalist
}

struct GetCoreApiByIDReq {
	id string @[json: 'id'; required]
}

struct GetCoreApiByIDResp {
	id           string     @[json: 'id']
	path         string     @[json: 'path']
	description  ?string    @[json: 'description']
	api_group    string     @[json: 'api_group']
	service_name string     @[json: 'service_name']
	method       string     @[json: 'method']
	is_required  u8         @[default: 0; json: 'is_required']
	source_type  string     @[json: 'source_type']
	source_id    string     @[json: 'source_id']
	created_at   ?time.Time @[json: 'created_at'; raw: '.format_ss()']
	updated_at   ?time.Time @[json: 'updated_at'; raw: '.format_ss()']
	deleted_at   ?time.Time @[json: 'deleted_at'; raw: '.format_ss()']
}
