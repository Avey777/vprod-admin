// ===========================
// module: parts.sys_admin.user
// ===========================
module user

import time

// ------------- domain parts / aggregates -------------
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

pub struct SysUserAggregate {
pub mut:
	user  SysUserPart
	roles []SysRolePart
}
