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
module mfa

import veb
import log
import time
import rand
import x.json2
import common.api { json_error, json_success }
import internal.structs { Context }
import common.jwt

@['/list'; post]
fn (app &MFA) captcha_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := captcha_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn captcha_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	random_num := fn () int {
		mut r := rand.new_default()
		return r.int_in_range(10000, 100000) or { 0 }
	}()

	mut data := map[string]Any{}
	data['code'] = random_num
	data['captcha_jwt'] = captcha_jwt_generate(random_num, req)
	return data
}

const secret = 'd8a3b1f0-6e7b-4c9a-9f2d-1c3e5f7a8b4c' //固定值，JWT有效性验证时使用

fn captcha_jwt_generate(random_num json2.Any, req json2.Any) string {
	mut payload := jwt.JwtPayload{
		iss:         'v-admin'   // 签发者 (Issuer) your-app-name
		sub:         'captcha'   // 用户唯一标识 (Subject)
		aud:         ['sys-api'] // 接收方 (Audience)，可以是数组或字符串
		exp:         time.now().add_seconds(120).unix() // 过期时间 (Expiration Time) 60秒后
		nbf:         time.now().unix() // 生效时间 (Not Before)，立即生效
		iat:         time.now().unix() // 签发时间 (Issued At)
		jti:         rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		captcha_opt: random_num.str()
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}
