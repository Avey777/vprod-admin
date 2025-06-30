module user

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

// Create Access Token | 创建 Access Token
@['/access_token'; post]
fn (app &User) access_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := access_token_resp(mut ctx, req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn access_token_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() or {panic} }

	time_now := time.now()
	secret := req.as_map()['secret'] or { '' }.str()
	expired_at := time_now.add_days(30).unix()
	req_user_id := req.as_map()['user_id'] or { '' }.str()

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut username := sys_user.select('username')!.where('id = ?', req_user_id)!.limit(1)!.query()!

	// 生成 token
	mut payload := jwt.JwtPayload{
		iss: 'v-admin'
		sub: req_user_id
		// aud: ['api-service', 'webapp']
		exp: expired_at
		nbf: time_now.unix()
		iat: time_now.unix()
		jti: rand.uuid_v4()
		// 自定义业务字段 (Custom Claims)
		roles:     ['', '']
		client_ip: ctx.ip()
		device_id: req.as_map()['device_id'] or { '' }.str()
	}
	token := jwt.jwt_generate(secret, payload)

	// token 写入数据库
	new_token := schema_sys.SysToken{
		id:         rand.uuid_v7()
		status:     u8(0)
		user_id:    req_user_id
		username:   username.str()
		token:      token
		source:     req.as_map()['source'] or { 'Core' }.str()
		expired_at: time.unix(expired_at)
		created_at: req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_token := orm.new_query[schema_sys.SysToken](db)
	sys_token.insert(new_token)!

	mut data := map[string]Any{}
	data['expired_at'] = expired_at.str()
	data['token'] = token
	return data
}
