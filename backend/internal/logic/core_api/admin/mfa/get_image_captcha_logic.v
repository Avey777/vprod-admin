/*
无状态验证码（Stateless CAPTCHA）
核心思路:
  1、不存储验证码答案，而是将答案加密后发送给客户端
  2、客户端提交时，服务器解密并验证
方案:
1、JWT
2、哈希挑战
*/

//使用JWT生成无状态图片验证码
module verify_code

import rand

fn main() {
	// 设置随机数生成器
	mut rng := rand.new_default()

	// 生成 10000 - 99999 范围内的随机整数
	random_num := rng.int_in_range(10000, 100000) or { 0 }

	println('随机数字: ${random_num}')
}
