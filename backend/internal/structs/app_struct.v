module structs

import veb
import internal.middleware.dbpool
import internal.middleware.config_loader

pub struct Context {
	veb.Context
pub mut:
	dbpool &dbpool.DatabasePool
	config &config_loader.GlobalConfig
}
