module user

import veb
import log
import common.api
import x.json2 as json
import structs { App, Context }
import services.sys_api.sys_admin.user
import dto.sys_admin.user as user_dto

pub struct User {
	App
}

// ----------------- Handler 层 -----------------
@['/id/ddd'; post]
pub fn (app &User) user_by_id_handler(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[user_dto.UserByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	result := user.find_user_by_id_usecase(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}
