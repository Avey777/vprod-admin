module structs

import veb
import internal.middleware.dbpool
import internal.middleware.conf

pub struct Context {
	veb.Context
pub mut:
	dbpool &dbpool.DatabasePool
	config &conf.GlobalConfig
	// authority rest.Middleware
	// dataperm  rest.Middleware
	// redis     redis.UniversalClient
	// casbin    &casbin.Enforcer
	// trans     &i18n.Translator
	// captcha   &base64Captcha.Captcha
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
pub mut:
	started chan bool // 用于通知应用程序已成功启动
}
