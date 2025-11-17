module menu

import veb
import log
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

fn delete_menu_resp(mut ctx Context, req DeleteMenuReq) !DeleteCoreMenuResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	sql db {
		delete from schema_core.CoreMenu where id == req.id
	} or { return error('Failed to delete menu: ${err}') }

	return DeleteCoreMenuResp{
		msg: 'CoreMenu Deleted successfully'
	}
}

struct DeleteMenuReq {
	id string @[json: 'id']
}

struct DeleteCoreMenuResp {
	msg string @[json: 'msg']
}
