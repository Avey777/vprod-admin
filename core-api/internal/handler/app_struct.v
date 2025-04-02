module handler

import veb
import internal.structs { Context }

pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
}
