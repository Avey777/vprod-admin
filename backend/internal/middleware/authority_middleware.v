module middleware

import veb
import x.json2
import internal.structs { Context }
import common.jwt

//认证中间件
pub fn authority_jwt_verify(mut ctx Context) bool {
	req := json2.raw_decode(ctx.req.data) or { return false }

	secret := req.as_map()['Secret'] or { '' }.str()
	auth_header := ctx.req.header.get(.authorization) or { '' }
	token := auth_header.all_after('Bearer').trim_space()
	dump(token)

	verify := jwt.jwt_verify(secret, token)
	if verify == false {
		ctx.res.set_status(.unauthorized)
		ctx.res.header.set(.content_type, 'application/json')
		// ctx.send_response_to_client('application/json', 'send_response_to_client')
		// ctx.request_error('request_error')
		// ctx.server_error('server_error')
		ctx.error('Bad credentials')
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
