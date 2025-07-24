module encrypt

import crypto.bcrypt
import crypto.sha256
import regex

// 必须与客户端完全一致的固定盐值
const client_salt = '7x!A@D#Ke9q2$}{{*)%~?'

pub fn bcrypt_hash(client_hash string) !string {
	if client_hash.len == 0 {
		return error('empty password')
	}
	return bcrypt.generate_from_password(client_hash.bytes(), bcrypt.default_cost)
}

pub fn bcrypt_verify(client_hash string, stored_hash string) bool {
	if !is_sha256_hash(client_hash) {
		return false
	}
	// if !contains_salt_signature(client_hash) {
	// 	return false
	// }
	if client_hash.len == 0 || stored_hash.len == 0 {
		return false
	}
	bcrypt.compare_hash_and_password(client_hash.bytes(), stored_hash.bytes()) or { return false }
	return true
}

// 检查盐值特征
fn contains_salt_signature(client_hash string) bool {
	// 计算盐值的特征片段
	expected_prefix := sha256.sum('${client_salt}|marker'.bytes()).hex()[0..21]
	return client_hash.contains(expected_prefix)
}

// 检查是否是 SHA-256 格式
fn is_sha256_hash(client_hash string) bool {
	if client_hash.len != 64 {
		return false
	}
	sha256_regex := regex.regex_opt(r'^[0-9a-fA-F]{64}$') or { return false }
	return sha256_regex.matches_string(client_hash)
}
