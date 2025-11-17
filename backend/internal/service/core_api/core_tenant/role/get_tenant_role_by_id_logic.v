module role

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/tenant_role/id'; post]
fn (app &Role) role_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetTenantRoleByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := role_by_id_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn role_by_id_resp(mut ctx Context, req GetTenantRoleByIdReq) ![]GetCoreApiByListResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_role := orm.new_query[schema_sys.SysRole](db)
	mut query := sys_role.select()!
	if req.role_id != '' {
		query = query.where('id = ?', req.role_id)!
	}
	result := query.query()!

	mut datalist := []GetCoreApiByListResp{} // map空数组初始化
	for row in result {
		data := GetCoreApiByListResp{
			id:             row.id
			status:         row.status
			name:           row.name
			code:           row.code
			default_router: row.default_router
			remark:         row.remark or { '' }
			sort:           row.sort
			data_scope:     row.data_scope
			created_at:     row.created_at
			updated_at:     row.updated_at
			deleted_at:     row.deleted_at or { time.Time{} }
		}

		datalist << data //追加data到maplist 数组
	}

	return datalist
}

struct GetTenantRoleByIdReq {
	role_id   string @[json: 'role_id']
	tenant_id string @[json: 'tenant_id']
}

struct GetCoreApiByListResp {
	id             string    @[json: 'id']
	status         u8        @[default: 0; json: 'status']
	name           string    @[json: 'name']
	code           string    @[json: 'code']
	default_router string    @[json: 'default_router']
	remark         string    @[json: 'remark']
	sort           u64       @[json: 'sort']
	data_scope     u8        @[json: 'data_scope']
	created_at     time.Time @[json: 'created_at']
	updated_at     time.Time @[json: 'updated_at']
	deleted_at     time.Time @[json: 'deleted_at']
}
