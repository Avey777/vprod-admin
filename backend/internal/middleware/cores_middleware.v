module middleware

import log
import veb
import internal.structs { Context }

const cors_origin = ['*', 'xx.com']

pub fn cores_middleware() veb.MiddlewareOptions[Context] {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 使用cors中间件行跨域处理 ｜ use veb's cors middleware to handle CORS requests
	mut cors_middleware_context := veb.cors[Context](veb.CorsOptions{
		// 允许跨域请求的域名 ｜ allow CORS requests from every domain
		origins: cors_origin // origins: ['*', 'xx.com']
		// 允许跨域请求的方法 ｜ allow CORS requests from methods:
		allowed_methods: [.get, .head, .patch, .put, .post, .delete, .options]
		allowed_headers:['Authorization','Content-Type','WWW-Authorization']
	})
	log.debug('${cors_middleware_context}')

	return cors_middleware_context
}

//备份跨域中间件使用方式
// pub fn cores_middleware(mut app App) {
// 	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

// 	// 使用cors中间件行跨域处理 ｜ use veb's cors middleware to handle CORS requests
// 	app.use(veb.cors[Context](veb.CorsOptions{
// 		// 允许跨域请求的域名 ｜ allow CORS requests from every domain
// 		origins: cors_origin // origins: ['*', 'xx.com']
// 		// 允许跨域请求的方法 ｜ allow CORS requests from methods:
// 		allowed_methods: [.get, .head, .patch, .put, .post, .delete, .options]
// 	}))
// }
