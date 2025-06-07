// JWT标准声明 (Standard Claims) https://datatracker.ietf.org/doc/html/rfc7519#section-4.1
module captcha

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
import time
import rand

// JWT 头部固定使用HS256算法 [使用这种方式，编译器会产生c错误]
const header_captcha = base64.url_encode_str(json.encode(JwtHeader{
	alg: 'HS256'
	typ: 'JWT'
}))

const captcha_secret = 'd8a3b1f0-6e7b-4c9a-9f2d-1c3e5f7a8b4c' //固定值，JWT有效性验证时使用

//生成captcha令牌
pub fn jwt_opt_generate() (string, string) {
	captch_obj := generate_captcha()

	payload_captcha := JwtPayload{
		iss: 'v-admin' // 签发者 (Issuer) your-app-name
		sub: 'captcha' // captcha唯一标识 (Subject)
		// aud: ['api-service', 'client'] // 接收方 (Audience)，可以是数组或字符串
		exp: time.now().add_seconds(120).unix() // 过期时间 (Expiration Time) 120秒后
		nbf: time.now().unix() // 生效时间 (Not Before)，立即生效
		iat: time.now().unix() // 签发时间 (Issued At)
		jti: rand.uuid_v4() // JWT唯一标识 (JWT ID)，防重防攻击
		// 自定义业务字段 (Custom Claims)
		captcha_text: captch_obj.text // 验证码
	}

	playload_64 := base64.url_encode_str(json.encode(payload_captcha))

	message := '${header_captcha}.${playload_64}'
	signature := hmac.new(captcha_secret.bytes(), message.bytes(), sha256.sum, 64)
	base64_signature := base64.url_encode_str(signature.bytestr())

	return '${header_captcha}.${playload_64}.${base64_signature}', captch_obj.image
}

// 验证令牌
pub fn jwt_verify(secret string, token string) bool {
	// 1.分割验证
	parts := token.split('.')
	if parts.len != 3 {
		return false
	}

	// 2. 验证头部
	// header_str := base64.url_decode_str(parts[0]) // or { return false }
	headers := json.decode(JwtHeader, base64.url_decode_str(parts[0])) or { return false }
	if headers.alg != 'HS256' || headers.typ != 'JWT' {
		return false
	}

	// 3. 验证签名（防时序攻击）
	message := '${parts[0]}.${parts[1]}'
	real_sig := hmac.new(secret.bytes(), message.bytes(), sha256.sum, 64)
	expected_sig := base64.url_encode_str(real_sig.bytestr())
	if !constant_time_compare(parts[2], expected_sig) {
		return false
	}

	// 解码payload
	// payload_str := base64.url_decode_str(parts[1]) // or { return false }
	payload := json.decode(JwtPayload, base64.url_decode_str(parts[1])) or { return false }

	// 4. 时间验证
	now := time.now().unix()
	// 检查exp（过期时间）和nbf（生效时间）
	if now >= payload.exp || now < payload.nbf {
		return false
	}

	return true
}

// 恒定时间比较
fn constant_time_compare(a string, b string) bool {
	if a.len != b.len {
		return false
	}
	mut result := u8(0)
	for i in 0 .. a.len {
		result |= a[i] ^ b[i]
	}
	return result == 0
}
