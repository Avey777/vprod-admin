module middleware

import veb
import internal.structs { Context }
import common.jwt
import log

//认证中间件
pub fn authority_jwt_verify(mut ctx Context) bool {
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
	token := auth_header.all_after('Bearer').trim_space()
	log.debug(token)

	verify := jwt.jwt_verify(secret, token)
	if verify == false {
		ctx.res.status_code = 401
		ctx.request_error('Authorization error')
		log.warn('Authorization error')
		return false
	}
	return true
}

//从 Token 获取用户信息（实际应查询数据库或缓存）
fn get_user_from_token(token string) {
	// 使用 JWT 解析或查询数据库来验证 token 并获取用户信息
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify // 显式初始化 handler 字段
		after:   false                // 显式初始化 after 字段
	}
}
