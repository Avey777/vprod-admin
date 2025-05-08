module dictionarydetail

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Delete dictionarydetail | 删除dictionarydetail
@['/delete_dictionarydetail'; post]
fn (app &DictionaryDetail) delete_dictionarydetail(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_dictionarydetail_resp(req) or {
		return ctx.json(json_error(503, '${err}'))
	}

	return ctx.json(json_success('success', result))
}

fn delete_dictionarydetail_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	dictionarydetail_id := req.as_map()['id'] or { '' }.str()

	mut sys_dictionarydetail := orm.new_query[schema.SysDictionaryDetail](db)
	sys_dictionarydetail.delete()!.where('id = ?', dictionarydetail_id)!.update()!
	// sys_dictionarydetail.set('del_flag = ?', 1)!.where('id = ?', dictionarydetail_id)!.update()!

	return map[string]Any{}
}
