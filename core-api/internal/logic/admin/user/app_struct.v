module user

import veb
import time
import internal.structs { Context }

type Any = string
	| []string
	| int
	| []int
	| []f64
	| bool
	| time.Time
	| map[string]int
	| []map[string]string
	| []map[string]Any

pub struct User {
	veb.Middleware[Context]
}
