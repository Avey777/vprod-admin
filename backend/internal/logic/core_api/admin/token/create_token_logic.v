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
		token:      token_jwt_generate()
		source:     req.as_map()['Source'] or { '' }.str()
		expired_at: req.as_map()['expiredAt'] or { time.now() }.to_time()!
		created_at: req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_token := orm.new_query[schema.SysToken](db)
	sys_token.insert(tokens)!

	return map[string]Any{}
}

fn token_jwt_generate() string {
	mut secret := 'b17989d7-57d2-4ffa-88ab-f6987feb3eec' // uuid_v4

	mut payload := jwt.JWTpayload{
		iss: 'vprod-workspase'
		sub: '0196b736-f807-73f0-8731-7a08c0ed75ea' // uuid_v7
		aud: ['api-service', 'webapp']
		exp: time.now().add_days(30).unix()
		nbf: time.now().unix()
		iat: time.now().unix()
		jti: '5907af3a-3f5a-4086-aaeb-68eca283d8d2' // unique-jwt-id-123
		// 自定义业务字段 (Custom Claims)
		name:      'Jengro'
		roles:     ['admin', 'editor']
		status:    'active'
		login_ip:  '192.168.1.100'
		device_id: 'device-xyz'
	}

	token := jwt.jwt_generate(secret, payload)
	return token
}
