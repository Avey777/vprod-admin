module main

import os
import veb

pub struct Context {
	veb.Context
}

pub struct App {
	veb.Middleware[Context]
}

pub fn (app &App) index(mut ctx Context) veb.Result {
	return ctx.html('<h1>Hello, World!</h1>')
}

fn main() {
	port := 8080
	mut app := &App{}
	app.use(veb.encode_gzip[Context]())
	veb.run[App, Context](mut app, port)
}
