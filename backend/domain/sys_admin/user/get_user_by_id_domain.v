// ===========================
// module: domain.sys_admin.user
// ===========================
module user

import parts.sys_admin.user as _ { SysRolePart, SysUserAggregate, SysUserPart }

// ===== Domain 层接口 =====
// 定义用户仓储接口，这里抽象了数据访问逻辑。
// Domain 层只关心“做什么”，不关心“怎么做”，体现 DDD 的“领域模型独立于基础设施”思想。
pub interface UserRepository {
mut:
	// 根据用户ID查询用户实体
	find_user_by_id_repo(user_id string) !SysUserPart

	// 查询用户所拥有的角色列表
	find_roles_by_user_id_repo(user_id string) ![]SysRolePart
}

// ===== Domain 层应用逻辑 =====
// 将用户和角色组合成聚合根对象 SysUserAggregate
pub fn get_user_aggregate_domain(mut repo UserRepository, user_id string) !SysUserAggregate {
	if user_id == '' {
		return error('user_id cannot be empty')
	}

	// 从仓储获取用户信息
	user := repo.find_user_by_id_repo(user_id)!

	// 从仓储获取用户角色
	roles := repo.find_roles_by_user_id_repo(user_id)!

	// 聚合用户和角色为聚合根对象返回
	return SysUserAggregate{
		user:  user
		roles: roles
	}
}
