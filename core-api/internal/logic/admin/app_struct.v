module admin

import veb

pub struct Context {
	veb.Context // logger &log.ThreadSafeLogger
}

pub struct Admin {
	// veb.Middleware[Context]
}
