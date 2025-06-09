module mfa

import rand
import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }
import regex
import common.opt

@['/list'; post]
fn (app &MFA) email_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := email_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

// 模块级常量（编译时初始化） - panic只会发生在编译阶段
const email_re = regex.regex_opt(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') or {
	panic('Invalid email regex pattern')
}

fn email_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	mut req_email := req.as_map()['email'] or { '' }.str()
	if req_email == '' {
		return error('Email error')
	}
	if !email_re.matches_string(req_email) { //验证邮箱格式
		return error('Invalid email format')
	}

	token_opt, opt_num := opt.opt_generate()

	mut db := db_mysql()
	defer { db.close() }

	infos := schema_sys.SysMFAlog{
		id:            rand.uuid_v7()
		verify_source: req_email
		method:        'Email'
		code:          opt_num.str()
		created_at:    req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
	}
	mut sys_info := orm.new_query[schema_sys.SysMFAlog](db)
	sys_info.insert(infos)!

	mut data := map[string]Any{}
	data['code'] = opt_num
	data['token_opt'] = token_opt

	return data
}
