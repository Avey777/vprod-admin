module api

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete api | 删除api
@['/delete_api'; post]
fn (app &Api) delete_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_api_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_api_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() or {panic} }

	api_id := req.as_map()['id'] or { '' }.str()

	mut sys_api := orm.new_query[schema_sys.SysApi](db)
	sys_api.delete()!.where('id = ?', api_id)!.update()!
	// sys_api.set('del_flag = ?', 1)!.where('id = ?', api_id)!.update()!

	return map[string]Any{}
}
