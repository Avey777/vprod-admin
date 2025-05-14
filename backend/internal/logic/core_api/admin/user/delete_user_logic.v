module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete User | 删除用户
@['/delete_user'; post]
fn (app &User) delete_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_user_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_user_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	user_id := req.as_map()['id'] or { '' }.str()

	mut sys_user := orm.new_query[schema.SysUser](db)
	sys_user.set('del_flag = ?', 1)!.where('id = ?', user_id)!.update()!

	return map[string]Any{}
}
