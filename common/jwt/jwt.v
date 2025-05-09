module main

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
import x.json2
import time




//JWT 头部固定使用HS256算法
const header = base64.url_encode_str(json.encode({
  "alg":"HS256"
  "typ":"JWT"
}))

//生成令牌
fn jwt_generate(secret string,payload map[string]Any) string {
  playload_64 := base64.url_encode_str(json.encode(payload))

  message := '${header}.${playload_64}'
  signature := hmac.new(secret.bytes(),message.bytes(),sha256.sum,0)
  base64_signature := base64.url_encode_str(signature.bytestr())
  return '${header}.${playload_64}.${base64_signature}'
}

// 验证令牌
fn jwt_verify(secret string, token string) bool {
  // 验证 token 长度
  parts := token.split('.')
  if parts.len != 3 {
      return false
  }
  // 验证 Header

  // 验证签名
  message := '${parts[0]}.${parts[1]}'
  signature := hmac.new(secret.bytes(), message.bytes(), sha256.sum, 0)
  expected_sig := base64.url_encode_str(signature.bytestr())
  if parts[2] != expected_sig{
    return false
  }
  // 验证时间有效性
  payload_json := base64.url_decode_str(parts[1])
  payload := json2.decode[Payload](payload_json.str()) or {return false}
  dump(payload)
  now := time.now().unix()
  if now > payload.exp || now < payload.nbf {
      return false
  }
  return true
}

fn main(){
  secret := '46546456'

  payload := {
    // 标准声明 (Standard Claims) https://datatracker.ietf.org/doc/html/rfc7519#section-4.1
    "iss": Any("vprod-workspase"),
    "sub": "user123",
    "aud": ["api-service", "webapp"],
    "exp": I64(time.now().add_days(30).unix()),
    "nbf": I64(time.now().unix()),
    "iat": I64(time.now().unix()),
    "jti": "unique-jwt-id-123",

    // 自定义业务字段 (Custom Claims)
    "name": "Jengro",
    "roles": ["admin", "editor"],
    "status": "active",
    "login_ip": "192.168.1.100",
    "device_id": "device-xyz"

  }

  token := jwt_generate(secret,payload)
  println(token)
  bj := jwt_verify(secret,token)
  println(bj)
}




struct Header {
    alg string
    typ string
}

struct Payload {
    // 标准声明
    iss string // 签发者 (Issuer) your-app-name
    sub string // 用户唯一标识 (Subject)
    aud []string // 接收方 (Audience)，可以是数组或字符串
    exp i64 // 过期时间 (Expiration Time) 7天后
    nbf i64 // 生效时间 (Not Before)，立即生效
    iat i64 // 签发时间 (Issued At)
    jti string // JWT唯一标识 (JWT ID)，防重放攻击

    // 自定义声明
    name   string // 用户姓名
    roles  []string // 用户角色
    status string  // 用户状态
    login_ip   string // ip地址
    device_id string // 设备id
}

type F64 = f64
type I64 = i64
type Any = string
	| []string
	| int
	| []int
	| I64
	| []f64
	| F64
	| bool
	| time.Time
	| map[string]int
	| map[string]string
	| []map[string]string
	| []map[string]Any
