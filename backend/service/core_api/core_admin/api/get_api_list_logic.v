module api

import veb
import log
import time
import orm
import x.json2 as json
import structs.schema_core
import common.api
import structs { Context }

@['/list'; post]
fn (app &Api) api_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetCoreApiByListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := api_list_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn api_list_resp(mut ctx Context, req GetCoreApiByListReq) !GetCoreApiByListResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreApi](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema_core.CoreApi
	}!
	offset_num := (req.page - 1) * req.page_size
	//*>>>*/
	mut query := sys_api.select()!
	if req.path != '' {
		query = query.where('path = ?', req.path)!
	}
	if req.api_group != '' {
		query = query.where('api_group = ?', req.api_group)!
	}
	if req.service_name != '' {
		query = query.where('service_name = ?', req.service_name)!
	}
	if req.is_required !in [0, 1] {
		query = query.where('is_required = ?', req.is_required)!
	}
	if req.method != '' {
		query = query.where('method = ?', req.method)!
	}

	result := query.limit(req.page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []GetCoreApiByList{} // map空数组初始化
	for row in result {
		mut data := GetCoreApiByList{ // map初始化
			id:           row.id //主键ID
			path:         row.path
			description:  row.description or { '' }
			api_group:    row.api_group
			method:       row.method
			is_required:  row.is_required
			service_name: row.service_name
			created_at:   row.created_at
			updated_at:   row.updated_at
			deleted_at:   row.deleted_at
		}
		datalist << data //追加data到maplist 数组
	}

	mut result_data := GetCoreApiByListResp{
		total: count
		data:  datalist
	}

	return result_data
}

struct GetCoreApiByListReq {
	page         int    @[json: 'page']
	page_size    int    @[json: 'page_size']
	path         string @[json: 'path']
	api_group    string @[json: 'api_group']
	service_name string @[json: 'service_name']
	method       string @[json: 'method']
	is_required  u8     @[json: 'is_required']
}

struct GetCoreApiByListResp {
	total int
	data  []GetCoreApiByList
}

pub struct GetCoreApiByList {
	id           string     @[json: 'id']
	path         string     @[json: 'path']
	description  ?string    @[json: 'description']
	api_group    string     @[json: 'api_group']
	service_name string     @[json: 'service_name']
	method       string     @[json: 'method']
	is_required  u8         @[default: 0; json: 'is_required']
	source_type  string     @[json: 'source_type']
	source_id    string     @[json: 'source_id']
	created_at   ?time.Time @[json: 'created_at'] //; raw: '.format_ss()'
	updated_at   ?time.Time @[json: 'updated_at'] //; raw: '.format_ss()'
	deleted_at   ?time.Time @[json: 'deleted_at'] //; raw: '.format_ss()'
}
