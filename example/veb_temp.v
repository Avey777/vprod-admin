module main

import veb

struct Context {
	veb.Context
}

struct App {
	veb.Middleware[Context]
}

struct Result {
	total int
	data  []map[string]string
}

fn (app &App) index(mut ctx Context) veb.Result {
	mut total := 3

	mut data := [{
		'id':   '1'
		'name': 'John'
	}, {
		'id':   '2'
		'name': 'Jane'
	}]

	result := Result{
		total: total
		data:  data
	}
	return ctx.json('${result}') //不正常
	// return ctx.json(result) //正常
}

fn main() {
	port := 28080
	mut app := &App{}
	veb.run[App, Context](mut app, port)
}
