module api

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Delete api | 删除api
@['/delete_api'; post]
fn (app &Api) delete_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_api_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_api_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	api_id := req.as_map()['id'] or { '' }.str()

	mut sys_api := orm.new_query[schema_core.CoreApi](db)
	sys_api.delete()!.where('id = ?', api_id)!.update()!
	// sys_api.set('del_flag = ?', 1)!.where('id = ?', api_id)!.update()!

	return map[string]Any{}
}
