module role

import veb
import log
import orm
import time
import x.json2
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Create role | 创建Role
@['/create_role'; post]
fn (app &Role) create_role(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.decode[json2.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := create_role_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_role_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	roles := schema_sys.SysRole{
		id:              rand.uuid_v7()
		status:          req.as_map()['status'] or { 0 }.u8()
		name:            req.as_map()['name'] or { '' }.str()
		code:            req.as_map()['code'] or { '' }.str()
		default_router:  req.as_map()['default_router'] or { '' }.str()
		remark:          req.as_map()['remark'] or { '' }.str()
		sort:            req.as_map()['sort'] or { 1 }.u32()
		data_scope:      req.as_map()['data_scope'] or { 1 }.u8()
		custom_dept_ids: req.as_map()['custom_dept_ids'] or { '' }.str()
		created_at:      req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:      req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_role := orm.new_query[schema_sys.SysRole](db)
	sys_role.insert(roles)!

	return map[string]Any{}
}
