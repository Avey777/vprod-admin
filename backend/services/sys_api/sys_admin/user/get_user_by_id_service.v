// ===========================
// module: services.sys_api.sys_admin.user
// ===========================
module user

import time
import structs { Context }
import parts.sys_admin.user as user_part { SysRolePart, UserRepository }
import dto.sys_admin.user as _ { UserById, UserByIdReq, UserByIdResp }
import domain.sys_admin.user as user_domain

// 映射角色 id / name
fn map_user_roles_to_ids_names(roles []SysRolePart) ([]string, []string) {
	role_ids := roles.map(it.id)
	role_names := roles.map(it.name)
	return role_ids, role_names
}

pub fn find_user_by_id_service(mut ctx Context, mut repo UserRepository, req UserByIdReq) !UserByIdResp {
	//
	user_domain.find_user_by_id_domain(mut ctx, req.user_id)!

	// 使用 Aggregate / UserParts
	mut user_parts := user_part.UserPart{
		user_repo: repo
	}

	agg := user_parts.get_user_with_roles(req.user_id)!

	role_ids, role_names := map_user_roles_to_ids_names(agg.roles)

	data := UserById{
		id:         agg.user.id
		username:   agg.user.username
		nickname:   agg.user.nickname
		status:     agg.user.status
		role_ids:   role_ids
		role_names: role_names
		avatar:     agg.user.avatar or { '' }
		desc:       agg.user.description or { '' }
		home_path:  agg.user.home_path
		mobile:     agg.user.mobile or { '' }
		email:      agg.user.email or { '' }
		creator_id: agg.user.creator_id or { '' }
		updater_id: agg.user.updater_id or { '' }
		created_at: agg.user.created_at.format_ss()
		updated_at: agg.user.updated_at.format_ss()
		deleted_at: (agg.user.deleted_at or { time.Time{} }).format_ss()
	}

	return UserByIdResp{
		datalist: [data]
	}
}
