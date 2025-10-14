module dictionary

import veb
import log
import time
import orm
import x.json2
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/id'; post]
fn (app &Dictionary) dictionary_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := dictionary_by_id_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn dictionary_by_id_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	dictionary_id := req.as_map()['id'] or { '' }.str()

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_dictionary := orm.new_query[schema_sys.SysDictionary](db)
	mut query := sys_dictionary.select()!
	if dictionary_id != '' {
		query = query.where('id = ?', dictionary_id)!
	}
	result := query.query()!

	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['title'] = row.title
		data['status'] = int(row.status)
		data['name'] = row.name
		data['desc'] = row.desc or { '' }

		data['created_at'] = row.created_at.format_ss()
		data['updated_at'] = row.updated_at.format_ss()
		data['deleted_at'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
