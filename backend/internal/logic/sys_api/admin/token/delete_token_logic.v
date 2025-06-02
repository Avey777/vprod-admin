module token

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete Token | 删除Token
@['/delete_token'; post]
fn (app &Token) delete_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_token_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_token_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	token_id := req.as_map()['id'] or { '' }.str()

	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.set('del_flag = ?', 1)!.where('id = ?', token_id)!.update()!

	return map[string]Any{}
}
