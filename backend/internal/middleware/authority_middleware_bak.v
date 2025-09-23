module middleware

// import veb
// import internal.structs { Context }
// import common.jwt
// import log

// //认证中间件
// pub fn authority_jwt_verify(mut ctx Context) bool {
// 	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

// 	secret := ctx.get_custom_header('secret') or { '' }
// 	log.debug(secret)
// 	auth_header := ctx.get_header(.authorization) or { '' }
// 	token := auth_header.all_after('Bearer').trim_space()
// 	log.debug(token)

// 	verify := jwt.jwt_verify(secret, token)
// 	if verify == false {
// 		ctx.request_error('Authorization error')
// 		log.warn('Authorization error')
// 		return false
// 	}
// 	return true
// }

// // 初始化中间件并设置 handler ,并返回中间件选项
// pub fn authority_middleware() veb.MiddlewareOptions[Context] {
// 	return veb.MiddlewareOptions[Context]{
// 		handler: authority_jwt_verify // 显式初始化 handler 字段
// 		after:   false                // 显式初始化 after 字段
// 	}
// }
