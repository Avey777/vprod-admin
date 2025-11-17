module dictionary

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Delete dictionary | 删除dictionary
@['/delete_dictionary'; post]
fn (app &Dictionary) delete_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_dictionary_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_dictionary_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	dictionary_id := req.as_map()['id'] or { '' }.str()

	mut sys_dictionary := orm.new_query[schema_sys.SysDictionary](db)
	sys_dictionary.delete()!.where('id = ?', dictionary_id)!.update()!
	// sys_dictionary.set('del_flag = ?', 1)!.where('id = ?', dictionary_id)!.update()!

	return map[string]Any{}
}
