module user

import veb
import log
import time
import rand
import x.json2 as json
import structs { Context }
import structs.schema_sys { SysToken, SysUser }
import common.api
import common.jwt
import orm

// ================================
// Handler 层
// ================================
@['/access_token'; post]
pub fn (app &User) access_token_handler(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[AccessTokenReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	resp := access_token_usecase(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(resp))
}

// ================================
// Usecase 层 | Application Service
// ================================
pub fn access_token_usecase(mut ctx Context, req AccessTokenReq) !AccessTokenResp {
	// 1️⃣ 调用 Domain 层生成 token
	token_data := generate_access_token_domain(mut ctx, req)!

	// 2️⃣ 写入数据库 (Repository)
	save_token(mut ctx, req, token_data)!

	return token_data
}

// ================================
// Domain 层 | 核心业务逻辑
// ================================
fn generate_access_token_domain(mut ctx Context, req AccessTokenReq) !AccessTokenResp {
	if req.user_id == '' {
		return error('user_id cannot be empty')
	}

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { log.warn('Failed to release DB connection: ${err}') }
	}

	// 获取用户名
	mut sys_user := orm.new_query[SysUser](db)
	user_rows := sys_user.select('username')!.where('id = ?', req.user_id)!.limit(1)!.query()!
	if user_rows.len == 0 {
		return error('User not found')
	}

	time_now := time.now()
	expired_at_unix := time_now.add_days(30).unix()

	// 生成 JWT
	payload := jwt.JwtPayload{
		iss:       'v-admin'
		sub:       req.user_id
		exp:       expired_at_unix
		nbf:       time_now.unix()
		iat:       time_now.unix()
		jti:       rand.uuid_v4()
		roles:     ['', '']
		client_ip: ctx.ip()
		device_id: req.device_id
	}
	token := jwt.jwt_generate(req.secret, payload)

	return AccessTokenResp{
		token:      token
		expired_at: time.unix(expired_at_unix)
	}
}

// ================================
// Repository 层 | 数据库访问
// ================================
fn save_token(mut ctx Context, req AccessTokenReq, resp AccessTokenResp) ! {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { log.warn('Failed to release DB connection: ${err}') }
	}

	new_token := SysToken{
		id:         rand.uuid_v7()
		status:     u8(0)
		user_id:    req.user_id
		username:   req.username
		token:      resp.token
		source:     req.source
		expired_at: resp.expired_at
		created_at: time.now()
		updated_at: time.now()
	}

	mut sys_token := orm.new_query[SysToken](db)
	sys_token.insert(new_token)!
}

// ================================
// DTO 层 | 请求/返回结构
// ================================
pub struct AccessTokenReq {
	id        string @[json: 'id']
	status    u8     @[json: 'status']
	user_id   string @[json: 'user_id']
	username  string @[json: 'username']
	token     string @[json: 'token']
	source    string @[json: 'source']
	secret    string @[json: 'secret']
	device_id string @[json: 'device_id']
}

pub struct AccessTokenResp {
	token      string    @[json: 'token']
	expired_at time.Time @[json: 'expired_at']
}
