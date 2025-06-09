// 用户认证模块 auth: authentication
module authentication

import veb
import log
import x.json2
import internal.config { db_mysql }
import common.api { json_error, json_success }
import internal.structs { Context }
import common.captcha

// Create Token | 创建Token
@['/login_by_email'; post]
fn (app &Authentication) get_captcha_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := get_captcha_resp(mut ctx, req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn get_captcha_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	captcha_token, captcha_image, _ := captcha.captcha_generate() // 生成token和captcha

	mut data := map[string]Any{}
	data['captcha_token'] = captcha_token
	data['captcha_image'] = captcha_image
	return data
}
