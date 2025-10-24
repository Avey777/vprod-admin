module role

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/tenant_role/list'; post]
fn (app &Role) role_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetTenantRoleListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := role_list_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn role_list_resp(mut ctx Context, req GetTenantRoleListReq) !GetTenantRoleListResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_role := orm.new_query[schema_core.CoreRole](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema_core.CoreUser
	}!
	offset_num := (req.page - 1) * req.page_size

	mut query := core_role.select()!
	if req.tenant_id != '' {
		query = query.where('tenant_id = ?', req.tenant_id)!
	}
	result := query.limit(req.page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []GetTenantRoleList{} // map空数组初始化
	for row in result {
		mut data := GetTenantRoleList{
			id:             row.id
			status:         row.status
			name:           row.name
			default_router: row.default_router
			remark:         row.remark or { '' }
			sort:           row.sort
			created_at:     row.created_at
			updated_at:     row.updated_at
			deleted_at:     row.deleted_at or { time.Time{} }
		}

		datalist << data //追加data到maplist 数组
	}

	mut result_data := GetTenantRoleListResp{
		total: count
		data:  datalist
	}

	return result_data
}

struct GetTenantRoleListReq {
	page      int    @[json: 'page']
	page_size int    @[json: 'page_size']
	name      string @[json: 'name']
	tenant_id string @[json: 'tenant_id']
}

struct GetTenantRoleListResp {
	total int
	data  []GetTenantRoleList
}

struct GetTenantRoleList {
	id             string    @[json: 'id']
	status         u8        @[default: 0; json: 'status']
	name           string    @[json: 'name']
	default_router string    @[json: 'default_router']
	remark         string    @[json: 'remark']
	sort           u64       @[json: 'sort']
	created_at     time.Time @[json: 'created_at']
	updated_at     time.Time @[json: 'updated_at']
	deleted_at     time.Time @[json: 'deleted_at']
}
