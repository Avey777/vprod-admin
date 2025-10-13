module mfa

// import rand
import veb
import log
// import time
// import orm
import x.json2
// import internal.structs.schema_sys
import common.api
import internal.structs { Context }
import regex
import common.opt

@['/login_by_email'; post]
fn (app &MFA) email_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := email_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

// 模块级常量（编译时初始化） - panic只会发生在编译阶段
const email_re = regex.regex_opt(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') or {
	panic('Invalid email regex pattern')
}

fn email_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	mut req_email := req.as_map()['email'] or { '' }.str()
	if req_email == '' {
		return error('Email error')
	}
	if !email_re.matches_string(req_email) { //验证邮箱格式
		return error('Invalid email format')
	}

	token_opt, opt_num := opt.opt_generate()

	// db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	// defer {
	// 	ctx.dbpool.release(conn) or {
	// 		log.warn('Failed to release connection ${@LOCATION}: ${err}')
	// 	}
	// }

	// infos := schema_sys.SysMFAlog{
	// 	id:            rand.uuid_v7()
	// 	verify_source: req_email
	// 	method:        'Email'
	// 	code:          opt_num.str()
	// 	created_at:    req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
	// }
	// mut sys_info := orm.new_query[schema_sys.SysMFAlog](db)
	// sys_info.insert(infos)!

	mut data := map[string]Any{}
	data['code'] = opt_num
	data['token_opt'] = token_opt

	return data
}
