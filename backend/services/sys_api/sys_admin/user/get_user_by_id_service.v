// ===========================
// module: services.sys_api.sys_admin.user
// ===========================
/*
services（应用服务层）
依赖 repo
依赖 domain
依赖 parts
依赖 dto
服务层串起所有层没问题
*/
module user

import structs { Context }
import dto.sys_admin.user as _ { UserByIdResp }
import parts.sys_admin.user as parts
import domain.sys_admin.user as domain
import adapters.repositories.user as repo_adapter

// 应用服务层入口
pub fn find_user_by_id_service(mut ctx Context, user_id string) !UserByIdResp {
	// Repository 实现了 Domain 层的接口
	mut repo := repo_adapter.UserRepo{
		ctx: &ctx
	}

	// 获取聚合对象
	agg := domain.get_user_aggregate_domain(mut repo, user_id)!

	// 转换为 API DTO 输出
	return parts.map_user_aggregate_to_dto_parts(agg)
}
