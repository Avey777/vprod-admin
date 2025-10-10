module middleware

import veb
import internal.structs { Context }
import common.jwt
import log

// Core认证中间件
fn authority_jwt_verify_core(mut ctx Context) bool {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	secret := ctx.get_custom_header('secret') or { '' }
	log.debug(secret)

	auth_header := ctx.get_header(.authorization) or { '' }
	log.debug(auth_header)
	if auth_header.len == 0 || !auth_header.starts_with('Bearer ') {
		ctx.res.status_code = 401
		ctx.request_error('Missing or invalid authentication token')
		return false
	}
	req_token := auth_header.all_after('Bearer').trim_space()
	log.debug(req_token)

	verify := jwt.jwt_verify(secret, req_token)
	if verify == false {
		ctx.res.status_code = 401
		ctx.request_error('Authorization error')
		log.warn('Authorization error')
		return false
	}

	// // >>>>> 验证用户权限 >>>>>
	// user_api_list := get_userapilist_from_token(mut ctx, req_token) or { return false }
	// if !user_api_list.contains('*') && ctx.req.url !in user_api_list {
	// 	ctx.res.status_code = 403
	// 	ctx.request_error("You don't have permission to perform this action")
	// 	return false
	// }
	// // <<<<< 验证用户权限 <<<<<

	return true
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware_core() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify_core // 显式初始化 handler 字段
		after:   false                     // 请求处理前执行
	}
}
