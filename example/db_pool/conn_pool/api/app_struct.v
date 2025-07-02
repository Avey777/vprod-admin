module api

import veb
// import pool
import dbpool { DBConnPool }

pub struct Context {
	veb.Context
pub mut:
	db_pool &DBConnPool
}
