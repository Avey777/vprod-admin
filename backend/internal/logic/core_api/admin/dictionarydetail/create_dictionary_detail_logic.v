module dictionarydetail

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

// Create dictionarydetail | 创建dictionarydetail
@['/create_dictionarydetail'; post]
fn (app &DictionaryDetail) create_dictionarydetail(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_dictionarydetail_resp(req) or {
		return ctx.json(json_error(503, '${err}'))
	}

	return ctx.json(json_success('success', result))
}

fn create_dictionarydetail_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	dictionary_details := schema_sys.SysDictionaryDetail{
		id:            rand.uuid_v7()
		title:         req.as_map()['Title'] or { '' }.str()
		key:           req.as_map()['Key'] or { '' }.str()
		value:         req.as_map()['Value'] or { '' }.str()
		dictionary_id: req.as_map()['DictionaryId'] or { '' }.str()
		sort:          req.as_map()['Sort'] or { 0 }.u32()
		status:        req.as_map()['Status'] or { 0 }.u8()
		created_at:    req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:    req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_dictionarydetail := orm.new_query[schema_sys.SysDictionaryDetail](db)
	sys_dictionarydetail.insert(dictionary_details)!

	return map[string]Any{}
}
