module department

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

// Delete department | 删除department
@['/delete_department'; post]
fn (app &Department) delete_department(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := delete_department_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_department_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	department_id := req.as_map()['id'] or { '' }.str()

	mut sys_department := orm.new_query[schema_sys.SysDepartment](db)
	sys_department.delete()!.where('id = ?', department_id)!.update()!
	// sys_department.set('del_flag = ?', 1)!.where('id = ?', department_id)!.update()!

	return map[string]Any{}
}
