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
	password := 'correct_password'
	wrong_password := 'wrong_password'

	hash := bcrypt_hash(password) or {
		eprintln('Failed to generate hash for test: ${err}')
		assert false
		return
	}

	// Test correct password
	assert bcrypt_verify(password, hash)

	// Test wrong password
	assert !bcrypt_verify(wrong_password, hash)

	// Test empty password
	assert !bcrypt_verify('', hash)

	// Test empty hash
	assert !bcrypt_verify(password, '')

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
