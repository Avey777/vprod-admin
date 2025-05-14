module middleware

import veb
import x.json2
import internal.structs { Context, json_error }
import common.jwt
import log

//认证中间件
pub fn authority_jwt_verify(mut ctx Context) bool {
	log.info('authority_jwt_verify authority_jwt_verify authority_jwt_verify')

	req := json2.raw_decode(ctx.req.data) or { return false }
	secret := req.as_map()['Secret'] or { '' }.str()
	auth_header := ctx.req.header.get(.authorization) or { '' }
	token := auth_header.all_after('Bearer').trim_space()
	log.info(token)

	verify := jwt.jwt_verify(secret, token)
	if verify == false {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.set(.content_type, 'application/json')
		ctx.send_response_to_client('application/json', json_error(401, 'send_response_to_client').str())

		ctx.error('Authorization error')
		return false
	}
	return true
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify // 显式初始化 handler 字段
		after:   false                // 显式初始化 after 字段
	}
}
