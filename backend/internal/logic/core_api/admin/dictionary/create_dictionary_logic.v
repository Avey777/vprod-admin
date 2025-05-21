module dictionary

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

// Create dictionary | 创建dictionary
@['/create_dictionary'; post]
fn (app &Dictionary) create_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_dictionary_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_dictionary_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	dictionarys := schema_sys.SysDictionary{
		id:         rand.uuid_v7()
		title:      req.as_map()['Title'] or { '' }.str()
		name:       req.as_map()['Name'] or { '' }.str()
		desc:       req.as_map()['Desc'] or { '' }.str()
		status:     req.as_map()['Status'] or { 0 }.u8()
		created_at: req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_dictionary := orm.new_query[schema_sys.SysDictionary](db)
	sys_dictionary.insert(dictionarys)!

	return map[string]Any{}
}
