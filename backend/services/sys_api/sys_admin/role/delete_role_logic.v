module role

import veb
import log
import orm
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

// Delete Role | 删除Role
@['/delete_role'; post]
fn (app &Role) delete_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_role_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_role_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	role_id := req.as_map()['id'] or { '' }.str()

	mut sys_role := orm.new_query[schema_sys.SysRole](db)
	sys_role.set('del_flag = ?', 1)!.where('id = ?', role_id)!.update()!

	return map[string]Any{}
}
