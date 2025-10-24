module role

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Update Role ||更新Role
@['/tenant_role/update'; post]
fn (app &Role) update_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateTenantRoleReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_role_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_role_resp(mut ctx Context, req UpdateTenantRoleReq) !string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_role := orm.new_query[schema_core.CoreRole](db)

	sys_role.set('status = ?', req.status)!
		.set('name = ?', req.name)!
		.set('code = ?', req.code)!
		.set('default_router = ?', req.default_router)!
		.set('remark = ?', req.remark)!
		.set('sort = ?', req.sort)!
		.set('data_scope = ?', req.data_scope)!
		.set('custom_dept_ids = ?', req.custom_dept_ids)!
		.set('updated_at = ?', req.updated_at)!
		.where('id = ?', req.role_id)!
		.update()!

	return 'Update Tenant Role successfully'
}

struct UpdateTenantRoleReq {
	role_id         string    @[json: 'role_id']
	tenant_id       string    @[json: 'tenant_id']
	status          u8        @[default: 0; json: 'status']
	name            string    @[json: 'name']
	code            string    @[json: 'code']
	default_router  string    @[json: 'default_router']
	remark          string    @[json: 'remark']
	sort            u64       @[json: 'sort']
	data_scope      u8        @[json: 'data_scope']
	custom_dept_ids string    @[json: 'custom_dept_ids']
	updated_at      time.Time @[json: 'updated_at']
}
