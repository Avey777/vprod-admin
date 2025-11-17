module authentication

import veb
import log
import orm
import time
import rand
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }
import common.jwt
import common.captcha
import common.encrypt

// Login by Account | 帐号登入
@['/login_by_account'; post]
fn (app &Authentication) login_by_account_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[LoginByAccountReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := login_by_account_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn login_by_account_resp(mut ctx Context, req LoginByAccountReq) !LoginByAccountResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	if captcha.captcha_verify(req.captcha_id, req.captcha_text) == false {
		return error('Captcha error')
	}

	mut core_user := orm.new_query[schema_core.CoreUser](db)
	mut user_info := core_user.select('id', 'username', 'password', 'status')!.where('username = ?',
		req.username)!.limit(1)!.query()!
	if user_info.len == 0 {
		return error('UserName not exit')
	}
	if !encrypt.bcrypt_verify(req.password, user_info[0].password) {
		return error('UserName or Password error')
	}

	expired_at := time.now().add_days(30)
	token_jwt := token_jwt_generate(mut ctx, req) // 生成token和captcha
	tokens := schema_core.CoreToken{
		id:         rand.uuid_v7()
		status:     req.status
		user_id:    req.user_id
		username:   req.username
		token:      token_jwt
		source:     req.source
		expired_at: expired_at
		created_at: time.now()
		updated_at: time.now()
	}

	mut core_token := orm.new_query[schema_core.CoreToken](db)
	core_token.insert(tokens)!

	data := LoginByAccountResp{
		expired_at: expired_at.str()
		token_jwt:  token_jwt
		user_id:    req.user_id
	}
	return data
}

fn token_jwt_generate(mut ctx Context, req LoginByAccountReq) string {
	secret := ctx.get_custom_header('secret') or { '' }

	mut payload := jwt.JwtPayload{
		iss: 'v-admin'   // 签发者 (Issuer) your-app-name
		sub: req.user_id // 用户唯一标识 (Subject)
		// aud: ['api-service', 'webapp'] // 接收方 (Audience)，可以是数组或字符串
		exp: time.now().add_days(30).unix() // 过期时间 (Expiration Time) 7天后
		nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
		iat: time.now().unix() // 签发时间 (Issued At)
		jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		// 自定义业务字段 (Custom Claims)
		roles:     ['admin', 'editor'] // 用户角色
		client_ip: req.login_ip or { '' }        // ip地址
		device_id: req.device_id or { '' }       // 设备id
	}

	token := jwt.jwt_generate(secret, payload)

	return token
}

struct LoginByAccountReq {
	username     string  @[json: 'username']
	password     string  @[json: 'password']
	captcha_text string  @[json: 'captcha_text']
	captcha_id   string  @[json: 'captcha_id']
	status       u8      @[json: 'status']
	user_id      string  @[json: 'user_id']
	source       string  @[json: 'source']
	login_ip     ?string @[json: 'login_ip']
	device_id    ?string @[json: 'device_id']
}

struct LoginByAccountResp {
	expired_at string @[json: 'expired_at']
	user_id    string @[json: 'user_id']
	token_jwt  string @[json: 'token_jwt']
}
