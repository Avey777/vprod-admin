module admin

import veb
import handler

// pub struct Context {
// 	veb.Context
// }

pub struct Admin {
	veb.Middleware[handler.Context]
}
