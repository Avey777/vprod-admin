// ===========================
// module: domain.sys_admin.user
// ===========================
module user

import parts.sys_admin.user as _ { SysRolePart, SysUserAggregate, SysUserPart }

pub interface UserRepository {
mut:
	find_user_by_id_repo(user_id string) !SysUserPart
	find_roles_by_user_id_repo(user_id string) ![]SysRolePart
}

pub fn err_user_empty() IError {
	return error('user_id cannot be empty')
}

pub fn get_user_aggregate(mut repo UserRepository, user_id string) !SysUserAggregate {
	if user_id == '' {
		return err_user_empty()
	}

	user := repo.find_user_by_id_repo(user_id)!
	roles := repo.find_roles_by_user_id_repo(user_id)!

	return SysUserAggregate{
		user:  user
		roles: roles
	}
}
