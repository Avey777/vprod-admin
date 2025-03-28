module base

import veb

struct Context {
	veb.Context // logger &log.ThreadSafeLogger
}

pub struct Base {
	// veb.Middleware[Context]
}
