module base

import veb
import internal.structs
// pub struct Context {
// 	veb.Context // logger &log.ThreadSafeLogger
// }

pub struct Base {
	veb.Middleware[structs.Context]
}
