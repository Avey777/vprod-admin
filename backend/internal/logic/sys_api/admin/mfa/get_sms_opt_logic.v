module mfa

import rand
import veb
import log
import time
import orm
import x.json2
import internal.structs.schema_sys
import common.api
import internal.structs { Context }
import regex
import common.opt

@['/login_by_sms'; post]
fn (app &MFA) sms_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := sms_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

// 模块级常量（编译时初始化） - panic只会发生在编译阶段
const phone_re = regex.regex_opt(r'^\+?[0-9]{1,4}?[-\s]?\(?[0-9]{1,4}\)?[-\s]?[0-9]{1,12}$') or {
	panic('Invalid phone regex pattern')
}

fn sms_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	mut req_phone := req.as_map()['Email'] or { '' }.str()
	if req_phone == '' {
		return error('Email error')
	}
	if !phone_re.matches_string(req_phone) { //验证邮箱格式
		return error('Invalid email format')
	}

	token_opt, opt_num := opt.opt_generate()

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	infos := schema_sys.SysMFAlog{
		id:            rand.uuid_v7()
		verify_source: req_phone
		method:        'SMS'
		code:          opt_num
		created_at:    req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
	}
	mut sys_info := orm.new_query[schema_sys.SysMFAlog](db)
	sys_info.insert(infos)!

	mut data := map[string]Any{}
	data['code'] = opt_num
	data['token_opt'] = token_opt

	return data
}
