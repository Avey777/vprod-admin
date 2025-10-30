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
import common.opt

// Login by Email | 邮箱登入
@['/login_by_email'; post]
fn (app &Authentication) login_by_email_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[LoginByEmailReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := login_by_email_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn login_by_email_resp(mut ctx Context, req LoginByEmailReq) !LoginByEmailResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	if opt.opt_verify(req.opt_token, req.opt_num) == false {
		return error('Captcha error')
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut user_info := sys_user.select('id', 'username', 'email', 'status')!.where('email = ?',
		req.email)!.limit(1)!.query()!
	if user_info.len == 0 {
		return error('email not exit')
	}

	expired_at := time.now().add_days(30)
	token_jwt := email_token_jwt_generate(mut ctx, req) // 生成token和captcha
	tokens := schema_sys.SysToken{
		id:         rand.uuid_v7()
		status:     req.status
		user_id:    req.user_id
		username:   user_info[0].username
		token:      token_jwt
		source:     req.source
		expired_at: expired_at
		created_at: time.now()
		updated_at: time.now()
	}
	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.insert(tokens)!

	data := LoginByEmailResp{
		expired_at: expired_at.str()
		token_jwt:  token_jwt
		user_id:    req.user_id
	}
	return data
}

fn email_token_jwt_generate(mut ctx Context, req LoginByEmailReq) string {
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
		client_ip: req.login_ip        // ip地址
		device_id: req.device_id       // 设备id
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}

struct LoginByEmailReq {
	status    u8     @[json: 'status']
	email     string @[json: 'email']
	opt_num   string @[json: 'opt_num']
	opt_token string @[json: 'opt_token']
	user_id   string @[json: 'user_id']
	source    string @[json: 'source']
	login_ip  string @[json: 'login_ip']
	device_id string @[json: 'device_id']
}

struct LoginByEmailResp {
	expired_at string @[json: 'expired_at']
	user_id    string @[json: 'user_id']
	token_jwt  string @[json: 'token_jwt']
}
