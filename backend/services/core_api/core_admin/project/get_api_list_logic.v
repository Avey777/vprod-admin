module project

import veb
import log
import time
import orm
import x.json2 as json
import structs.schema_core
import common.api
import structs { Context }

@['/list'; post]
fn (app &Project) project_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetCoreProjectByListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := project_list_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn project_list_resp(mut ctx Context, req GetCoreProjectByListReq) !GetCoreProjectByListResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreProject](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema_core.CoreProject
	}!
	offset_num := (req.page - 1) * req.page_size
	//*>>>*/
	mut query := sys_api.select()!
	if req.name != '' {
		query = query.where('name = ?', req.name)!
	}
	if req.display_name != '' {
		query = query.where('api_group = ?', req.display_name)!
	}

	result := query.limit(req.page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []GetCoreProjectByList{} // map空数组初始化
	for row in result {
		mut data := GetCoreProjectByList{ // map初始化
			id:           row.id //主键ID
			name:         row.name
			display_name: row.display_name
			description:  row.description
			created_at:   row.created_at
			updated_at:   row.updated_at
			deleted_at:   row.deleted_at
		}
		datalist << data //追加data到maplist 数组
	}

	mut result_data := GetCoreProjectByListResp{
		total: count
		data:  datalist
	}

	return result_data
}

struct GetCoreProjectByListReq {
	page         int    @[json: 'page']
	page_size    int    @[json: 'page_size']
	name         string @[json: 'name']
	display_name string @[json: 'display_name']
}

struct GetCoreProjectByListResp {
	total int
	data  []GetCoreProjectByList
}

pub struct GetCoreProjectByList {
	id           string     @[json: 'id']
	name         string     @[json: 'name']
	display_name ?string    @[json: 'display_name']
	logo         string     @[json: 'logo']
	description  ?string    @[json: 'description']
	created_at   ?time.Time @[json: 'created_at'] //; raw: '.format_ss()'
	updated_at   ?time.Time @[json: 'updated_at'] //; raw: '.format_ss()'
	deleted_at   ?time.Time @[json: 'deleted_at'] //; raw: '.format_ss()'
}
