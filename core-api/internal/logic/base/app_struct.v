module base

import veb
import internal.structs { Context }

pub struct Base {
	veb.Middleware[Context]
}
