module ports

pub interface UserRepository {
	find_user_by_id(user_id string) !SysUser
	find_roles_by_id(user_id string) ![]SysRole
}

pub struct SysUser {
	id       string
	name     string
	nickname string
	email    string
}

pub struct SysRole {
	id   string
	name string
}
