module structs

import veb
import common.jwt { JwtPayload }
import internal.middleware.dbpool
import internal.middleware.conf

pub struct Context {
	veb.Context
pub mut:
	dbpool      &dbpool.DatabasePool
	config      &conf.GlobalConfig
	jwt_payload JwtPayload
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
pub mut:
	started chan bool // 用于通知应用程序已成功启动
}
