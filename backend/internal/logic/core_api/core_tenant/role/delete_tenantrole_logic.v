module role

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Delete Role | 删除Role
@['/tenant_role/delete'; post]
fn (app &Role) delete_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[DeleteTenantRoleReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := delete_role_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_role_resp(mut ctx Context, req DeleteTenantRoleReq) !string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_role := orm.new_query[schema_core.CoreRole](db)
	sys_role.set('del_flag = ?', 1)!.where('id = ?', req.role_id)!.update()!

	return 'Delete Tenant Role Successfully'
}

struct DeleteTenantRoleReq {
	role_id string @[json: 'role_id']
}
