module project

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/id'; post]
fn (app &Project) project_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetCoreProjectByIDReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := project_by_id_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn project_by_id_resp(mut ctx Context, req GetCoreProjectByIDReq) ![]GetCoreProjectByIDResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreProject](db)
	mut query := sys_api.select()!
	if req.id != '' {
		query = query.where('id = ?', req.id)!.limit(1)!
	}
	result := query.query()!
	if result.len == 0 {
		return error('API not found')
	}

	mut datalist := []GetCoreProjectByIDResp{} // map空数组初始化
	for row in result {
		resp_obj := GetCoreProjectByIDResp{
			id:           row.id
			name:         row.name
			display_name: row.display_name
			logo:         row.logo
			description:  row.description
			created_at:   row.created_at
			updated_at:   row.updated_at
			deleted_at:   row.deleted_at
		}

		datalist << resp_obj //追加resp_obj到maplist 数组
	}

	return datalist
}

struct GetCoreProjectByIDReq {
	id string @[json: 'id'; required]
}

struct GetCoreProjectByIDResp {
	id           string     @[json: 'id']
	name         string     @[json: 'name'; required]
	display_name ?string    @[json: 'display_name']
	logo         string     @[json: 'logo']
	description  ?string    @[json: 'description']
	created_at   ?time.Time @[json: 'created_at'] //; raw: '.format_ss()'
	updated_at   ?time.Time @[json: 'updated_at'] //; raw: '.format_ss()'
	deleted_at   ?time.Time @[json: 'deleted_at'] //; raw: '.format_ss()'
}
