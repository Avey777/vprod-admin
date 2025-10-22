module menu

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Delete menu | 删除menu
@['/delete_menu'; post]
fn (app &Menu) delete_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[DeleteMenuReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := delete_menu_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_menu_resp(mut ctx Context, req DeleteMenuReq) !string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_menu := orm.new_query[schema_core.CoreMenu](db)
	sys_menu.delete()!.where('id = ?', req.id)!.update()!
	// sys_menu.set('del_flag = ?', 1)!.where('id = ?', DeleteMenuReq)!.update()!

	return 'CoreMenu Deleted successfully'
}

struct DeleteMenuReq {
	id string @[json: 'id']
}
