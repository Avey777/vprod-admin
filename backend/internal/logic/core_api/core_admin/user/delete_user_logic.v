module user

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Delete User | 删除用户
@['/delete_user'; post]
fn (app &User) delete_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[DeleteUserReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := delete_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_user_resp(mut ctx Context, req DeleteUserReq) !DeleteUserResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_user := orm.new_query[schema_core.CoreUser](db)
	core_user.set('del_flag = ?', 1)!.where('id = ?', req.user_id)!.update()!

	return DeleteUserResp{
		msg: 'User deleted successfully'
	}
}

struct DeleteUserReq {
	user_id string
}

struct DeleteUserResp {
	msg string
}
