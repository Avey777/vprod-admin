module token

import veb
import log
import orm
import time
import rand
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }
import common.jwt

// Create Token | 创建Token
@['/create_token'; post]
fn (app &Token) create_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_token_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_token_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	tokens := schema.SysToken{
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
	mut sys_token := orm.new_query[schema.SysToken](db)
	sys_token.insert(tokens)!

	return map[string]Any{}
}

fn token_jwt_generate(req json2.Any) string {
	mut secret := 'b17989d7-57d2-4ffa-88ab-f6987feb3eec' // uuid_v4

	mut payload := jwt.JWTpayload{
		iss: 'v-admin' // 签发者 (Issuer) your-app-name
		sub: req.as_map()['UserId'] or { '' }.str() // 用户唯一标识 (Subject)
		aud: ['api-service', 'webapp'] // 接收方 (Audience)，可以是数组或字符串
		exp: time.now().add_days(30).unix() // 过期时间 (Expiration Time) 7天后
		nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
		iat: time.now().unix() // 签发时间 (Issued At)
		jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		// 自定义业务字段 (Custom Claims)
		name:      req.as_map()['UserName'] or { '' }.str() // 用户姓名
		roles:     ['admin', 'editor'] // 用户角色
		status:    req.as_map()['Status'] or { '0' }.str() // 用户状态
		login_ip:  '192.168.1.100' // ip地址
		device_id: 'device-xyz'    // 设备id
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}
