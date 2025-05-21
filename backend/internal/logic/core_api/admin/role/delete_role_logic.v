module role

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete Role | 删除Role
@['/delete_role'; post]
fn (app &Role) delete_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_role_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_role_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	role_id := req.as_map()['id'] or { '' }.str()

	mut sys_role := orm.new_query[schema_sys.SysRole](db)
	sys_role.set('del_flag = ?', 1)!.where('id = ?', role_id)!.update()!

	return map[string]Any{}
}
