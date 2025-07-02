module structs

import veb
// import internal.mideleware { DBConnPool }

pub struct Context {
	veb.Context // pub mut:
	// 	db_pool &DBConnPool
}
