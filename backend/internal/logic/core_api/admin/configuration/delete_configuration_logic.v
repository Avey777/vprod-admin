module configuration

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Delete configuration | 删除configuration
@['/delete_configuration'; post]
fn (app &Configuration) delete_configuration(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := delete_configuration_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn delete_configuration_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	configuration_id := req.as_map()['id'] or { '' }.str()

	mut sys_configuration := orm.new_query[schema.SysConfiguration](db)
	sys_configuration.delete()!.where('id = ?', configuration_id)!.update()!
	// sys_configuration.set('del_flag = ?', 1)!.where('id = ?', configuration_id)!.update()!

	return map[string]Any{}
}
