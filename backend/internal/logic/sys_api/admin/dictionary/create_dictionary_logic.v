module dictionary

import veb
import log
import orm
import time
import x.json2
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Create dictionary | 创建dictionary
@['/create_dictionary'; post]
fn (app &Dictionary) create_dictionary(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := create_dictionary_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_dictionary_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	dictionarys := schema_sys.SysDictionary{
		id:         rand.uuid_v7()
		title:      req.as_map()['title'] or { '' }.str()
		name:       req.as_map()['name'] or { '' }.str()
		desc:       req.as_map()['desc'] or { '' }.str()
		status:     req.as_map()['status'] or { 0 }.u8()
		created_at: req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_dictionary := orm.new_query[schema_sys.SysDictionary](db)
	sys_dictionary.insert(dictionarys)!

	return map[string]Any{}
}
