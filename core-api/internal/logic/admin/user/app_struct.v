module user

import veb
import internal.structs { Context }

pub struct User {
	veb.Middleware[Context]
}
