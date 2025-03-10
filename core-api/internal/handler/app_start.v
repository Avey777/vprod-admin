module handler

import veb
import log
// import config
// import rand
import internal.structs { json_success }

const cors_origin = ['*', 'xx.com']

pub struct Context {
	veb.Context
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
}

pub fn new_app() {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut app := &App{} // 实例化 App 结构体 并返回指针
	register_routes(mut app) // veb.Controller  使用路由控制器 | handler/register_routes.v
	// app.use(veb.decode_gzip[Context]()) //使用解码gzip中间件

	// 使用cors中间件行跨域处理 ｜ use veb's cors middleware to handle CORS requests
	app.use(veb.cors[Context](veb.CorsOptions{
		// 允许跨域请求的域名 ｜ allow CORS requests from every domain
		origins: cors_origin // origins: ['*', 'xx.com']
		// 允许跨域请求的方法 ｜ allow CORS requests from methods:
		allowed_methods: [.get, .head, .patch, .put, .post, .delete, .options]
	}))

	port := 9009 // config.set_web_port()
	veb.run_at[App, Context](mut app, host: '', port: port, family: .ip6, timeout_in_seconds: 30) or {
		panic(err)
	}
}

pub fn (app &App) before_request() {
	$if trace_before_request ? {
		eprintln('[veb] before_request: ${app.req.method} ${app.req.url}')
	}
}

// 此方法将仅处理对 index 页面的GET请求 ｜ This method will only handle GET requests to the index page
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success(1, 'req success'))
}
