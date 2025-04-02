module handler

import veb
import internal.structs
// pub struct Context {
// 	veb.Context
// }

pub struct App {
	veb.Middleware[structs.Context]
	veb.Controller
	veb.StaticHandler
}
