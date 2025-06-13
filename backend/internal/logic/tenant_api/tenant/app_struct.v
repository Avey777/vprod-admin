module tenant

import veb
import internal.structs { Context }

pub struct Tenant {
	veb.Middleware[Context]
}
