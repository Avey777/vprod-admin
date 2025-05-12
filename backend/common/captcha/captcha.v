module main

import db.sqlite
import rand
// import time

// 验证码配置
pub struct Config {
pub:
	key_length int = 6   // 验证码位数
	expire_sec int = 300 // 过期时间（秒）
}

// 验证码处理器
pub struct Captcha {
	db     &sqlite.DB
	config Config
}

// Conf is the captcha configuration structure
// options:[digit,string,math,chinese];
struct Conf {
	key_long   int    @[default: 5; env: CAPTCHA_KEY_LONG; josn: 'KeyLong'; optional]      // captcha length
	img_width  int    @[default: 240; env: CAPTCHA_IMG_WIDTH; json: 'ImgWidth'; optional]  // captcha width
	img_height int    @[default: 80; env: CAPTCHA_IMG_HEIGHT; json: 'ImgHeight'; optional] // captcha height
	driver     string @[default: 'digit'; env: CAPTCHA_DRIVER; json: 'Driver'; optional; options: ''digit','string','math','chinese''] // captcha type
}

fn main() {
	digit := rand.intn(99999) or { 0 }
	dump(digit)
}
