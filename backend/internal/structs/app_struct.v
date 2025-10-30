module structs

import veb
import common.jwt { JwtPayload }
import internal.dbpool
import internal.config

pub struct Context {
	veb.Context
pub mut:
	dbpool      &dbpool.DatabasePool
	config      &config.GlobalConfig
	jwt_payload JwtPayload
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
pub mut:
	started chan bool // 用于通知应用程序已成功启动
}
