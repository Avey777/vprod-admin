module user

import structs { Context }
import structs.schema_sys
import adapters.repositories.user

// ----------------- Domain 层 -----------------
pub fn user_by_id_domain_ddd(mut ctx Context, user_id string) !schema_sys.SysUser {
	// 核心业务逻辑，例如参数校验、权限检查等
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	// 调用 Repository 获取用户数据
	return user.find_user_by_id(mut ctx, user_id)!
}
