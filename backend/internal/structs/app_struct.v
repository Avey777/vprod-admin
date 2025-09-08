module structs

import veb
import internal.middleware.dbpool
import internal.middleware.conf

pub struct Context {
	veb.Context
pub mut:
	dbpool &dbpool.DatabasePool
	config &conf.GlobalConfig
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
}
