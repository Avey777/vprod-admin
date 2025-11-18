module user

import log
import time
import dto.sys_admin.user { UserByIdResp }
import parts.sys_admin.user as parts_user { UserParts }

// ----------------- Application / Usecase 层 -----------------
pub fn find_user_by_id_usecase_ddd(part &UserParts, user_id string) !UserByIdResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	aggregate := part.get_user_with_roles(user_id)!

	role_ids := aggregate.roles.map(it.id)
	role_names := aggregate.roles.map(it.name)

	data := UserById{
		id:         aggregate.user.id
		username:   aggregate.user.username
		nickname:   aggregate.user.nickname
		status:     aggregate.user.status
		role_ids:   role_ids
		role_names: role_names
		avatar:     aggregate.user.avatar or { '' }
		desc:       aggregate.user.description or { '' }
		home_path:  aggregate.user.home_path
		mobile:     aggregate.user.mobile or { '' }
		email:      aggregate.user.email or { '' }
		creator_id: aggregate.user.creator_id or { '' }
		updater_id: aggregate.user.updater_id or { '' }
		created_at: aggregate.user.created_at.format_ss()
		updated_at: aggregate.user.updated_at.format_ss()
		deleted_at: (aggregate.user.deleted_at or { time.Time{} }).format_ss()
	}

	return UserByIdResp{
		datalist: [data]
	}
}
