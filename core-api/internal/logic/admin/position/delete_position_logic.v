module position

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Delete position | 删除Position
@['/delete_position'; post]
fn (app &Position) delete_position(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_position_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_position_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	position_id := req.as_map()['id'] or { '' }.str()

	mut sys_position := orm.new_query[schema.SysPosition](db)
	sys_position.set('del_flag = ?', 1)!.where('id = ?', position_id)!.update()!

	return map[string]Any{}
}
