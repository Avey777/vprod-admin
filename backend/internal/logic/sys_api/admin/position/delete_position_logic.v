module position

import veb
import log
import orm
import x.json2

import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete position | 删除Position
@['/delete_position'; post]
fn (app &Position) delete_position(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_position_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg()) ) }

	return ctx.json(api.json_success_200(result) )
}

fn delete_position_resp(mut ctx Context,req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	position_id := req.as_map()['id'] or { '' }.str()

	mut sys_position := orm.new_query[schema_sys.SysPosition](db)
	sys_position.delete()!.where('id = ?', position_id)!.update()!
	// sys_position.set('del_flag = ?', 1)!.where('id = ?', position_id)!.update()!

	return map[string]Any{}
}
