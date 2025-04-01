module admin

import veb

pub struct Context {
	veb.Context
}

pub struct Admin {
	veb.Middleware[Context]
}
