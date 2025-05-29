module verify_code

import rand

fn main() {
	// 设置随机数生成器
	mut rng := rand.new_default()

	// 生成 10000 - 99999 范围内的随机整数
	random_num := rng.int_in_range(10000, 100000) or { 0 }

	println('随机数字: ${random_num}')
}
