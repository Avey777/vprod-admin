// ===========================
// module: handler.sys_admin
// ===========================
module sys_admin

import veb
import log
import x.json2 as json
import structs { App, Context }
import dto.sys_admin.user { UserByIdReq }
import services.sys_api.sys_admin.user as user_app_service
import common.api

pub struct User {
	App
}

@['/id'; post]
pub fn (mut app User) find_user_by_id_handler(mut ctx Context) veb.Result {
	log.debug('${@METHOD} ${@MOD}.${@FILE_LINE}')

	req := json.decode[UserByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	if req.user_id.trim_space() == '' {
		return ctx.json(api.json_error_400('user_id cannot be empty'))
	}

	result := user_app_service.find_user_by_id_service(mut ctx, req.user_id) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}
