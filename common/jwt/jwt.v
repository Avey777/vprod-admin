module main

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
import time


//JWT 头部固定使用HS256算法
const header = base64.url_encode_str(json.encode({
  "alg":"HS256"
  "typ":"JWT"
}))

//生成令牌
fn generate(secret string,payload map[string]string) string {
  playload_64 := base64.url_encode_str(json.encode(payload))
  message := '${header}.${playload_64}'
  signature := hmac.new(secret.bytes(),message.bytes(),sha256.sum,0)
  return '${header}.${playload_64}.${base64.url_encode_str(signature.bytestr())}'
}


fn main(){
  secret := '46546456'
  payload := {
    "sub": "user123",
    "name": "Jengro",
    // "admin": true,
    "iat": time.now().format_ss()
    "exp": time.now().add_days(1).format_ss()
  }

  token := generate(secret,payload)
  println(token)
}


//验证令牌
// fn verify(secret string,token string) bool {
//   parts := token.split('.')
//   if parts.len != 3 {return false}

//   sig := base64.url_encode_str(parts[2])
//   expected_sig := hmac.new(secret.bytes(),'${parts[0]}.${parts[1]}'.bytes(), sha256.sum)
//   return sig == expected_sig
// }
