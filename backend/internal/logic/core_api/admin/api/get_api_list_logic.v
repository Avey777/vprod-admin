module api

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_error, json_success }
import internal.structs { Context }

@['/list'; post]
fn (app &Api) api_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := api_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn api_list_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or { 1 }.int()
	page_size := req.as_map()['pageSize'] or { 10 }.int()
	path := req.as_map()['Path'] or { '' }.str()
	api_group := req.as_map()['Group'] or { '' }.str()
	service_name := req.as_map()['ServiceName'] or { '' }.str()
	method := req.as_map()['Method'] or { '' }.str()
	is_required := req.as_map()['IsRequired'] or { 'Null' }.u8()

	mut db := db_mysql()
	defer { db.close() }
	mut sys_api := orm.new_query[schema.SysApi](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema.SysUser
	}!
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query := sys_api.select()!
	if path != '' {
		query = query.where('path = ?', path)!
	}
	if api_group != '' {
		query = query.where('api_group = ?', api_group)!
	}
	if service_name != '' {
		query = query.where('service_name = ?', service_name)!
	}
	if is_required !in [0, 1] {
		query = query.where('is_required = ?', is_required)!
	}
	if method != '' {
		query = query.where('method = ?', method)!
	}

	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['Path'] = row.path
		data['Description'] = row.description or { '' }
		data['Group'] = row.api_group
		data['Method'] = row.method
		data['IsRequired'] = int(row.is_required)
		data['ServiceName'] = row.service_name

		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	mut result_data := map[string]Any{}
	result_data['total'] = count
	result_data['data'] = datalist

	return result_data
}
