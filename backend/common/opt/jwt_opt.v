// JWT标准声明 (Standard Claims) https://datatracker.ietf.org/doc/html/rfc7519#section-4.1
module opt

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
// import x.json2
import time
import rand

// JWT 头部固定使用HS256算法 [使用这种方式，编译器会产生c错误]
const header_opt = base64.url_encode_str(json.encode(JwtHeader{
	alg: 'HS256'
	typ: 'JWT'
}))

/*>>>>>>>>>>>>>captcha_jwt>>>>>>>>>>>>>*/
const opt_secret = 'd8a3b1f0-6e7b-4c9a-9f2d-1c3e5f7a8b4c' //固定值，JWT有效性验证时使用

fn random_num() string {
	random_num := fn () int {
		mut r := rand.new_default()
		return r.int_in_range(10000, 100000) or { 0 }
	}()
	return random_num.str()
}

//生成captcha_opt令牌
pub fn opt_generate() (string,string) {
  opt_num := random_num().str()

  payload_captcha := JwtPayload{
	iss: 'v-admin'      // 签发者 (Issuer) your-app-name
	sub: 'captcha' // captcha唯一标识 (Subject)
	// aud: ['api-service', 'client'] // 接收方 (Audience)，可以是数组或字符串
	exp: time.now().add_seconds(120).unix() // 过期时间 (Expiration Time) 120秒后
	nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
	iat: time.now().unix() // 签发时间 (Issued At)
	jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
	// 自定义业务字段 (Custom Claims)
	opt_text: opt_num // 验证码
  }

	playload_64 := base64.url_encode_str(json.encode(payload_captcha))

	message := '${header_opt}.${playload_64}'
	signature := hmac.new(opt_secret.bytes(), message.bytes(), sha256.sum, 64)
	base64_signature := base64.url_encode_str(signature.bytestr())

	return '${header_opt}.${playload_64}.${base64_signature}',opt_num
}


// 验证captcha_opt令牌
pub fn opt_verify(token string, opt_num string) bool {
	// 验证 token 长度
	parts := token.split('.')
	if parts.len != 3 {
		return false
	}
	// 验证签名
	message := '${parts[0]}.${parts[1]}'
	signature := hmac.new(opt_secret.bytes(), message.bytes(), sha256.sum, 64)
	expected_sig := base64.url_encode_str(signature.bytestr())
	if parts[2] != expected_sig {
		return false
	}
	// 验证时间有效性
	payload_base64 := base64.url_decode_str(parts[1])
	payload_json := json.decode(JwtPayload, payload_base64.str()) or { return false }
	now := time.now().unix()
	if now > payload_json.exp || now < payload_json.nbf {
		return false
	}
	// 验证 captcha
	if opt_num != payload_json.opt_text {
		return false
	}
	return true
}
