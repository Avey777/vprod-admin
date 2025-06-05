// 用户认证模块 auth: authentication
module authentication

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

// Create Token | 创建Token
@['/login_by_account'; post]
fn (app &Authentication) login_by_account_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := login_by_account_resp(mut ctx, req) or {
		return ctx.json(json_error(503, '${err}'))
	}

	return ctx.json(json_success('success', result))
}

fn login_by_account_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }
	username := req.as_map()['UserName'] or { return error('Please enter your account') }.str()
	password := req.as_map()['Password'] or { return error('Please input a password') }.str()
	expired_at := req.as_map()['expiredAt'] or { time.now().add_days(30).unix() }.to_time()!
	captcha_num := req.as_map()['captchaNum'] or { return error('Please input captcha_num') }.str()
	captcha_jwt := req.as_map()['captchaJWT'] or { return error('Please return captcha_jwt') }.str()

	if jwt.jwt_opt_verify(captcha_jwt, captcha_num) == false {
		return error('Captcha error')
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut user_info := sys_user.select('id', 'username', 'password', 'status')!.where('username = ?',
		username)!.limit(1)!.query()!
	if user_info.len == 0 {
		return error('UserName not exit')
	}
	if user_info[0].password != password {
		return error('UserName or Password error')
	}

	token_jwt := token_jwt_generate(mut ctx, req) // 生成token和captcha
	tokens := schema_sys.SysToken{
		id:         rand.uuid_v7()
		status:     req.as_map()['Status'] or { 0 }.u8()
		user_id:    req.as_map()['UserId'] or { '' }.str()
		username:   username
		token:      token_jwt
		source:     req.as_map()['Source'] or { '' }.str()
		expired_at: expired_at
		created_at: time.now()
		updated_at: time.now()
	}
	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.insert(tokens)!

	mut data := map[string]Any{}
	data['expiredAt'] = expired_at.str()
	data['token'] = token_jwt
	data['userId'] = user_info[0].id
	return data
}

fn token_jwt_generate(mut ctx Context, req json2.Any) string {
	// secret := req.as_map()['Secret'] or { '' }.str()
	secret := ctx.get_custom_header('secret') or { '' }

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
