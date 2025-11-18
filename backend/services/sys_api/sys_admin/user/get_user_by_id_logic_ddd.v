module user

import log
import time
import structs { Context }
import structs.schema_sys { SysRole }
import adapters.repositories.user as repo
import domain.sys_admin.user as user_domain
import dto.sys_admin.user { UserByIdReq, UserByIdResp }

// ----------------- Application / Usecase 层 -----------------
pub fn find_user_by_id_usecase_ddd(mut ctx Context, req UserByIdReq) !UserByIdResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 调用 Domain 层逻辑
	user_data := user_domain.user_by_id_domain_ddd(mut ctx, req.user_id)!

	// 调用 Repository 获取额外信息
	user_roles := repo.find_user_roles_by_userid(mut ctx, req.user_id)!

	role_ids := user_roles.map(it.id)
	role_names := user_roles.map(fn (r SysRole) string {
		return r.name
	})

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
