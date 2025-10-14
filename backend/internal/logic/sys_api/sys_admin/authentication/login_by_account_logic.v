// 用户认证模块 auth: authentication
module authentication

import veb
import log
import orm
import time
import rand
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }
import common.jwt
import common.captcha
import common.encrypt

// Login by Account | 帐号登入
@['/login_by_account'; post]
fn (app &Authentication) login_by_account_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := login_by_account_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn login_by_account_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	username := req.as_map()['username'] or { return error('Please enter your account') }.str()
	password := req.as_map()['password'] or { return error('Please input a password') }.str()
	captcha_text := req.as_map()['captcha'] or { return error('Please input captcha_text') }.str()
	captcha_id := req.as_map()['captcha_id'] or { return error('Please return captcha_id') }.str()

	if captcha.captcha_verify(captcha_id, captcha_text) == false {
		return error('Captcha error')
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut user_info := sys_user.select('id', 'username', 'password', 'status')!.where('username = ?',
		username)!.limit(1)!.query()!
	if user_info.len == 0 {
		return error('UserName not exit')
	}
	if !encrypt.bcrypt_verify(password, user_info[0].password) {
		return error('UserName or Password error')
	}

	expired_at := time.now().add_days(30)
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
	data['expired_at'] = expired_at.str()
	data['token_jwt'] = token_jwt
	data['user_id'] = user_info[0].id
	return data
}

fn token_jwt_generate(mut ctx Context, req json.Any) string {
	secret := ctx.get_custom_header('secret') or { '' }

	mut payload := jwt.JwtPayload{
		iss: 'v-admin' // 签发者 (Issuer) your-app-name
		sub: req.as_map()['user_id'] or { '' }.str() // 用户唯一标识 (Subject)
		// aud: ['api-service', 'webapp'] // 接收方 (Audience)，可以是数组或字符串
		exp: time.now().add_days(30).unix() // 过期时间 (Expiration Time) 7天后
		nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
		iat: time.now().unix() // 签发时间 (Issued At)
		jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		// 自定义业务字段 (Custom Claims)
		roles:     ['admin', 'editor'] // 用户角色
		client_ip: req.as_map()['login_ip'] or { '' }.str() // ip地址
		device_id: req.as_map()['device_id'] or { '' }.str() // 设备id
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}
