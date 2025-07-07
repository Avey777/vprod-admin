module structs

import veb
import internal.middleware.dbpool

pub struct Context {
	veb.Context
pub mut:
	dbpool &dbpool.DatabasePool
}
