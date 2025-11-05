module structs

import veb
import common.jwt { JwtPayload }
import internal.dbpool
import internal.config
import internal.i18n

pub struct Context {
	veb.Context
pub mut:
	dbpool      &dbpool.DatabasePool
	config      &config.GlobalConfig
	jwt_payload JwtPayload

	i18n       &i18n.I18nStore   = unsafe { nil }
	extra_i18n map[string]string = map[string]string{}
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
pub mut:
	started chan bool // 用于通知应用程序已成功启动
}
