module captcha

// fn test_captcha_generate() {
// 	token, captcha_image := captcha_generate()
// 	dump(token)
// 	// dump(captcha_image)
// 	assert token != ''
// 	assert typeof(token).name == 'string'
// 	assert typeof(token).name.len > 0
// }

fn test_captcha_verify() {
	token, captcha_image, captcha_text := captcha_generate()
	// captcha_text := ''
	verify := captcha_verify(token, captcha_text)
	assert verify == true
}
