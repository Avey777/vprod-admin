// ===========================
// module: user
// ===========================
module user

import time

//-------------接口--------------------

pub interface UserRepository {
mut:
	find_user_by_id_repo(user_id string) !SysUserPart
	find_roles_by_user_id_repo(user_id string) ![]SysRolePart
}

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

//-------------聚合逻辑--------------------
@[heap]
pub struct UserPart {
pub mut:
	user_repo &UserRepository
}

pub struct SysUserAggregate {
pub mut:
	user  SysUserPart
	roles []SysRolePart
}

// 获取用户及其角色
pub fn (mut p UserPart) get_user_with_roles(user_id string) !SysUserAggregate {
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	user_info := p.user_repo.find_user_by_id_repo(user_id)!
	roles := p.user_repo.find_roles_by_user_id_repo(user_id)!

	return SysUserAggregate{
		user:  user_info
		roles: roles
	}
}
