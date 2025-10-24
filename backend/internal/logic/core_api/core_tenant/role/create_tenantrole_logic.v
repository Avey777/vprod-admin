module role

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Create role | 创建Role
@['/tenant_role/create'; post]
fn (app &Role) create_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateTenantRoleReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_role_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_role_resp(mut ctx Context, req CreateTenantRoleReq) !string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	time_now := time.now()
	roles := schema_core.CoreRole{
		id:             rand.uuid_v7()
		tenant_id:      req.tenant_id
		name:           req.name
		default_router: req.default_router
		remark:         req.remark
		sort:           req.sort
		status:         req.status
		type:           req.type
		updater_id:     req.updater_id
		updated_at:     time_now
		creator_id:     req.creator_id
		created_at:     time_now
	}

	mut core_role := orm.new_query[schema_core.CoreRole](db)
	core_role.insert(roles)!

	return 'Tenant role created successfully'
}

struct CreateTenantRoleReq {
	id             string  @[json: 'id']
	tenant_id      string  @[json: 'tenant_id']
	name           string  @[json: 'name']
	default_router string  @[json: 'default_router']
	remark         ?string @[json: 'remark']
	sort           u32     @[json: 'sort']
	status         u8      @[json: 'status']
	type           string  @[json: 'type']
	updater_id     ?string @[json: 'updater_id']
	creator_id     ?string @[json: 'creator_id']
}
