module admin

import veb
import structt

// pub struct Context {
// 	veb.Context
// }

pub struct Admin {
	veb.Middleware[structt.Context]
}
