module admin

import veb
import internal.structs
// pub struct Context {
// 	veb.Context // logger &log.ThreadSafeLogger
// }

pub struct Admin {
	veb.Middleware[structs.Context]
}
