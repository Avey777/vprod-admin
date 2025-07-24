module encrypt

fn test_bcrypt_hash() {
	password := 'test_password_123'
	hash := bcrypt_hash(password) or {
		eprintln('bcrypt_encrypt failed: ${err}')
		assert false
		return
	}
	dump(hash)

	assert hash.len > 0
	assert hash != password
}

fn test_bcrypt_verify() {
	// 原始密码 123456： '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'
	// client_hash := '7f2d5b9e8c3a0f6d1b4e7c2a9d8e3f5b6c1a0d2e5f8b3c6d9e2f5a8b1c4d7e0' //前端sha512 hash +salt
	client_hash := '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92' //前端sha512 hash
	wrong_password := 'wrong_password'

	hash := bcrypt_hash(client_hash) or {
		eprintln('Failed to generate hash for test: ${err}')
		assert false
		return
	}

	// Test correct client_hash
	assert bcrypt_verify(client_hash, hash)

	// Test wrong client_hash
	assert !bcrypt_verify(wrong_password, hash)

	// Test empty client_hash
	assert !bcrypt_verify('', hash)

	// Test empty stored_hash
	assert !bcrypt_verify(client_hash, '')

	// Test both empty
	assert !bcrypt_verify('', '')
}

fn test_bcrypt_hash_empty_password() {
	_ := bcrypt_hash('') or {
		// This should fail
		assert err.msg().contains('empty') // Checking if error mentions empty password
		return
	}
	assert false // Shouldn't reach here
}
