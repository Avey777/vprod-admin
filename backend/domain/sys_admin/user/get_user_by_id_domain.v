// ===========================
// module: domain.sys_admin.user
// ===========================
module user

import structs { Context }
import adapters.repositories.user { UserRepo }
import parts.sys_admin.user as _ { SysUserPart }

// ----------------- Domain 层 -----------------
pub fn find_user_by_id_domain(mut ctx Context, user_id string) !SysUserPart {
	// 核心业务逻辑，例如参数校验、权限检查等
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	mut repo := UserRepo{
		ctx: &ctx
	}

	user_info := repo.find_user_by_id_repo(user_id)!
	return user_info
}
