module logic

// import veb
// import log
// import time
// import x.json2
// import internal.config { db_mysql }
// import internal.structs.schema
// import internal.structs { Context, json_error, json_success }

// type Any = string
// 	| []string
// 	| int
// 	| []int
// 	| bool
// 	| time.Time
// 	| map[string]int
// 	| []map[string]string
// 	| []map[string]Any

// @['/info'; post]
// fn (app &User) user_info_logic(mut ctx Context) veb.Result {
// 	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

// 	req_data := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

// 	mut result := user_info(req_data) or { return ctx.json(json_error(503, '${err}')) }
// 	return ctx.json(json_success('success', result))
// }

// pub fn user_info(req_data json2.Any) !map[string]Any {
// 	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

// 	page := req_data.as_map()['page'] or { 1 }.int()
// 	page_size := req_data.as_map()['page_size'] or { 10 }.int()

// 	mut db := db_mysql()
// 	defer { db.close() }

// 	return map[string]Any{}
// }
