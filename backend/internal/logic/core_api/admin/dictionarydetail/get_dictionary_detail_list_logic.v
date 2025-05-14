module dictionarydetail

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_success, json_error }
import internal.structs { Context }

@['/list'; post]
fn (app &DictionaryDetail) dictionarydetail_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := dictionarydetail_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn dictionarydetail_list_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or { 1 }.int()
	page_size := req.as_map()['pageSize'] or { 10 }.int()
	dictionary_id := req.as_map()['Name'] or { '' }.str()
	key := req.as_map()['Leader'] or { '' }.str()
	status := req.as_map()['Status'] or { 0 }.u8()

	mut db := db_mysql()
	defer { db.close() }
	mut sys_dictionarydetail := orm.new_query[schema.SysDictionaryDetail](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema.SysUser
	}!
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query := sys_dictionarydetail.select()!
	if dictionary_id != '' {
		query = query.where('dictionary_id = ?', dictionary_id)!
	}
	if key != '' {
		query = query.where('key = ?', key)!
	}
	if status in [0, 1] {
		query = query.where('status = ?', status)!
	}
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['Title'] = row.title
		data['Status'] = int(row.status)
		data['Key'] = row.key
		data['Value'] = row.value
		data['DictionaryId'] = row.dictionary_id
		data['Sort'] = int(row.sort)
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
