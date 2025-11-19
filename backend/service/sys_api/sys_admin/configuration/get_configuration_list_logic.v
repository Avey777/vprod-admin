module configuration

import veb
import log
import time
import orm
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

@['/list'; post]
fn (app &Configuration) configuration_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := configuration_list_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn configuration_list_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or { 1 }.int()
	page_size := req.as_map()['page_size'] or { 10 }.int()
	name := req.as_map()['name'] or { '' }.str()
	key := req.as_map()['key'] or { '' }.str()
	category := req.as_map()['category'] or { 0 }.u8()

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_configuration := orm.new_query[schema_sys.SysConfiguration](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema_sys.SysUser
	}!
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query := sys_configuration.select()!
	if name != '' {
		query = query.where('name = ?', name)!
	}
	if key != '' {
		query = query.where('leader = ?', key)!
	}
	if category in [0, 1] {
		query = query.where('status = ?', category)!
	}
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['status'] = int(row.status)
		data['name'] = row.name
		data['key'] = row.key
		data['value'] = row.value
		data['category'] = row.category
		data['remark'] = row.remark or { '' }
		data['Sosortrt'] = int(row.sort)

		data['created_at'] = row.created_at.format_ss()
		data['updated_at'] = row.updated_at.format_ss()
		data['deleted_at'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	mut result_data := map[string]Any{}
	result_data['total'] = count
	result_data['data'] = datalist

	return result_data
}
