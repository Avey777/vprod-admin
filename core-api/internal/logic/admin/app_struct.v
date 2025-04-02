module admin

import veb
import internal.structs { Context }

pub struct Admin {
	veb.Middleware[Context]
}
