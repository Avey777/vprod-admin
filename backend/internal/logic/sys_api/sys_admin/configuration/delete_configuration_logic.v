module configuration

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Delete configuration | 删除configuration
@['/delete_configuration'; post]
fn (app &Configuration) delete_configuration(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_configuration_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_configuration_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	configuration_id := req.as_map()['id'] or { '' }.str()

	mut sys_configuration := orm.new_query[schema_sys.SysConfiguration](db)
	sys_configuration.delete()!.where('id = ?', configuration_id)!.update()!
	// sys_configuration.set('del_flag = ?', 1)!.where('id = ?', configuration_id)!.update()!

	return map[string]Any{}
}
