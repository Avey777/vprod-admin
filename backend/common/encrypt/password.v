module encrypt

import crypto.bcrypt

pub fn bcrypt_hash(password string) !string {
	if password.len == 0 {
		return error('empty password')
	}
	return bcrypt.generate_from_password(password.bytes(), bcrypt.default_cost)
}

pub fn bcrypt_verify(password string, hash string) bool {
	if password.len == 0 || hash.len == 0 {
		return false
	}
	bcrypt.compare_hash_and_password(password.bytes(), hash.bytes()) or { return false }
	return true
}
