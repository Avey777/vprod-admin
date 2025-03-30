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
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut app := &App{} // 实例化 App 结构体 并返回指针
	register_handlers(mut app) // veb.Controller  使用路由控制器 | handler/register_routes.v
	cores_middleware(mut app)

	mut port := 9009  //config.set_web_port()
	veb.run_at[App, Context](mut app, host: '', port: port, family: .ip6, timeout_in_seconds: 30) or {
		panic(err)
	}
}

// 此方法将仅处理对 index 页面的GET请求 ｜ This method will only handle GET requests to the index page
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success('req success', ''))
}
