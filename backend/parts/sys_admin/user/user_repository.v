module user

import time

//-------------接口--------------------
pub interface UserRepository {
	find_by_id(user_id string) !SysUserPart
	find_roles_by_user_id(user_id string) ![]SysRolePart
}

pub struct SysUserPart {
pub:
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
pub:
	id   string
	name string
}

//-------------聚合逻辑--------------------
pub struct UserParts {
pub:
	user_repo &UserRepository
}

pub struct SysUserAggregate {
pub:
	user  SysUserPart
	roles []SysRolePart
}

pub fn (p &UserParts) get_user_with_roles(user_id string) !SysUserAggregate {
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	user := p.user_repo.find_by_id(user_id)!
	roles := p.user_repo.find_roles_by_user_id(user_id)!

	return SysUserAggregate{
		user:  user
		roles: roles
	}
}
