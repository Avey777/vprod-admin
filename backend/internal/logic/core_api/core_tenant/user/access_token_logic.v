module user

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

// Create Access Token | 创建 Access Token
@['/access_token'; post]
fn (app &User) access_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[AccessTokenReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := access_token_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn access_token_resp(mut ctx Context, req AccessTokenReq) !AccessTokenResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	time_now := time.now()
	expired_at := time_now.add_days(30).unix()

	mut core_user := orm.new_query[schema_core.CoreUser](db)
	mut username := core_user.select('username')!.where('id = ?', req.user_id)!.limit(1)!.query()!

	// 生成 token
	mut payload := jwt.JwtPayload{
		iss: 'v-admin'
		sub: req.user_id
		// aud: ['api-service', 'webapp']
		exp: expired_at
		nbf: time_now.unix()
		iat: time_now.unix()
		jti: rand.uuid_v4()
		// 自定义业务字段 (Custom Claims)
		roles:     ['', '']
		client_ip: ctx.ip()
		device_id: req.device_id
	}
	token := jwt.jwt_generate(req.secret, payload)

	// token 写入数据库
	new_token := schema_core.CoreToken{
		id:         rand.uuid_v7()
		status:     u8(0)
		user_id:    req.user_id
		username:   username.str()
		token:      token
		source:     req.source
		expired_at: time.unix(expired_at)
		created_at: time_now
		updated_at: time_now
	}
	mut core_token := orm.new_query[schema_core.CoreToken](db)
	core_token.insert(new_token)!

	data := AccessTokenResp{
		expired_at: time.unix(expired_at)
		token:      token
	}
	return data
}

struct AccessTokenReq {
	id        string @[json: 'id']
	status    u8     @[json: 'status']
	user_id   string @[json: 'user_id']
	username  string @[json: 'username']
	token     string @[json: 'token']
	source    string @[json: 'source']
	secret    string @[json: 'secret']
	device_id string @[json: 'device_id']
}

struct AccessTokenResp {
	token      string    @[json: 'token']
	expired_at time.Time @[json: 'expired_at']
}
