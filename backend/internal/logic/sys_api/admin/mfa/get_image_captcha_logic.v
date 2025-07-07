/*
无状态验证码（Stateless CAPTCHA）
核心思路:
  1、不存储验证码答案，而是将答案加密后发送给客户端
  2、客户端提交时，服务器解密并验证
方案:
1、JWT
2、哈希挑战
*/

//使用JWT生成无状态图片验证码
// 用户认证模块 auth: authentication
module mfa

import veb
import log
import x.json2

import common.api
import internal.structs { Context }
import common.captcha

// Get captcha image | 获取验证码图片
@['/login_by_email'; post]
fn (app &MFA) get_captcha_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := get_captcha_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg()) ) }

	return ctx.json(api.json_success_200(result) )
}

fn get_captcha_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	captcha_token, captcha_image, _ := captcha.captcha_generate() // 生成token和captcha

	mut data := map[string]Any{}
	data['captcha_token'] = captcha_token
	data['captcha_image'] = captcha_image
	return data
}
