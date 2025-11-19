// ===========================
// module: parts.sys_admin.user
// ===========================
module user

import time

// ===== 领域模型部分对象 (Entity/Value Object) =====
// DDD 中的 Part 是聚合的一部分，可以组合成 Aggregate

pub struct SysUserPart {
pub mut:
	id          string
	username    string
	nickname    string
	status      u8
	avatar      ?string
	description ?string
	home_path   string
	mobile      ?string
	email       ?string
	creator_id  ?string
	updater_id  ?string
	created_at  time.Time
	updated_at  time.Time
	deleted_at  ?time.Time
}

pub struct SysRolePart {
pub mut:
	id   string
	name string
}

// 聚合根
pub struct SysUserAggregate {
pub mut:
	user  SysUserPart
	roles []SysRolePart
}
