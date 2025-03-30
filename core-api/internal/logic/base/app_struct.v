module base

import veb

pub struct Context {
	veb.Context // logger &log.ThreadSafeLogger
}

pub struct Base {
	// veb.Middleware[Context]
}
