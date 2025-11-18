module user

import time
import structs { Context }
import structs.schema_sys { SysRole }
import dto.sys_admin.user { UserById, UserByIdReq, UserByIdResp }
import adapters.repositories.user as user2 { find_user_by_id, find_user_roles_by_userid }

// 参数校验
fn validate_user_id(user_id string) ! {
	if user_id == '' {
		return error('user_id cannot be empty')
	}
}

// 映射角色 id / name
fn map_user_roles_to_ids_names(roles []SysRole) ([]string, []string) {
	role_ids := roles.map(it.id)
	role_names := roles.map(fn (r SysRole) string {
		return r.name
	})
	return role_ids, role_names
}

// 核心 Usecase
pub fn find_user_by_id_service(mut ctx Context, req UserByIdReq) !UserByIdResp {
	validate_user_id(req.user_id)!

	user_data := find_user_by_id(mut ctx, req.user_id)!
	user_roles := find_user_roles_by_userid(mut ctx, req.user_id)!

	role_ids, role_names := map_user_roles_to_ids_names(user_roles)

	data := UserById{
		id:         user_data.id
		username:   user_data.username
		nickname:   user_data.nickname
		status:     user_data.status
		role_ids:   role_ids
		role_names: role_names
		avatar:     user_data.avatar or { '' }
		desc:       user_data.description or { '' }
		home_path:  user_data.home_path
		mobile:     user_data.mobile or { '' }
		email:      user_data.email or { '' }
		creator_id: user_data.creator_id or { '' }
		updater_id: user_data.updater_id or { '' }
		created_at: user_data.created_at.format_ss()
		updated_at: user_data.updated_at.format_ss()
		deleted_at: (user_data.deleted_at or { time.Time{} }).format_ss()
	}

	return UserByIdResp{
		datalist: [data]
	}
}
