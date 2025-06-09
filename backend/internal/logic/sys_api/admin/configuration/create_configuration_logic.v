module configuration

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Create configuration | 创建configuration
@['/create_configuration'; post]
fn (app &Configuration) create_configuration(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_configuration_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_configuration_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	configurations := schema_sys.SysConfiguration{
		id:         rand.uuid_v7()
		name:       req.as_map()['name'] or { '' }.str()
		status:     req.as_map()['status'] or { 0 }.u8()
		key:        req.as_map()['key'] or { '' }.str()
		value:      req.as_map()['value'] or { '' }.str()
		sort:       req.as_map()['sort'] or { 0 }.u32()
		category:   req.as_map()['category'] or { '' }.str()
		remark:     req.as_map()['remark'] or { '' }.str()
		created_at: req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_configuration := orm.new_query[schema_sys.SysConfiguration](db)
	sys_configuration.insert(configurations)!

	return map[string]Any{}
}
