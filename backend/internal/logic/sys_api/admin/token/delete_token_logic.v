module token

import veb
import log
import orm
import x.json2
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Delete Token | 删除Token
@['/delete_token'; post]
fn (app &Token) delete_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.decode[json2.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_token_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_token_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	token_id := req.as_map()['id'] or { '' }.str()

	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.set('del_flag = ?', 1)!.where('id = ?', token_id)!.update()!

	return map[string]Any{}
}
