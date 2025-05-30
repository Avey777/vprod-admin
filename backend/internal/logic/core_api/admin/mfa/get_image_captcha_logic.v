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

// fn main() {
// 	// 设置随机数生成器
// 	mut rng := rand.new_default()

// 	// 生成 10000 - 99999 范围内的随机整数
// 	random_num := rng.int_in_range(10000, 100000) or { 0 }

// 	println('随机数字: ${random_num}')
// }
import veb
import log
import orm
import time
import rand
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
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

	mut db := db_mysql()
	defer { db.close() }

	tokens := schema_sys.SysToken{
		id:         rand.uuid_v7()
		status:     req.as_map()['Status'] or { 0 }.u8()
		user_id:    req.as_map()['UserId'] or { '' }.str()
		username:   req.as_map()['UserName'] or { '' }.str()
		token:      token_jwt_generate(req)
		source:     req.as_map()['Source'] or { '' }.str()
		expired_at: req.as_map()['expiredAt'] or { time.now() }.to_time()!
		created_at: req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.insert(tokens)!

	return map[string]Any{}
}

fn token_jwt_generate(req json2.Any) string {
	// secret := req.as_map()['Secret'] or { '' }.str()
	secret := Context{}.get_custom_header('secret') or { '' }

	mut payload := jwt.JwtPayload{
		iss: 'v-admin' // 签发者 (Issuer) your-app-name
		sub: req.as_map()['UserId'] or { '' }.str() // 用户唯一标识 (Subject)
		// aud: ['api-service', 'webapp'] // 接收方 (Audience)，可以是数组或字符串
		exp: time.now().add_days(30).unix() // 过期时间 (Expiration Time) 7天后
		nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
		iat: time.now().unix() // 签发时间 (Issued At)
		jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		// 自定义业务字段 (Custom Claims)
		roles:     ['admin', 'editor'] // 用户角色
		client_ip: req.as_map()['LoginIp'] or { '' }.str() // ip地址
		device_id: req.as_map()['DeviceId'] or { '' }.str() // 设备id
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}
