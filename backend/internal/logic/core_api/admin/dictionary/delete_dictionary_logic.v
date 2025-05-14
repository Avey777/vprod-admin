module dictionary

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_success, json_error }
import internal.structs { Context }

// Delete dictionary | 删除dictionary
@['/delete_dictionary'; post]
fn (app &Dictionary) delete_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_dictionary_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_dictionary_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	dictionary_id := req.as_map()['id'] or { '' }.str()

	mut sys_dictionary := orm.new_query[schema.SysDictionary](db)
	sys_dictionary.delete()!.where('id = ?', dictionary_id)!.update()!
	// sys_dictionary.set('del_flag = ?', 1)!.where('id = ?', dictionary_id)!.update()!

	return map[string]Any{}
}
