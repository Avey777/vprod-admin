// ===========================
// module: parts.sys_admin.user
// ===========================
/*
parts（领域数据结构，可复用定义）
依赖 dto（因为 Part 要用 DTO 类型或结构）
被 repo、domain、services 使用
*/
module user

import time
import dto.sys_admin.user as dto { UserByIdResp }
// 将 Domain 层聚合对象转换为 DTO，用于 API 输出

pub fn map_user_aggregate_to_dto_parts(agg SysUserAggregate) UserByIdResp {
	role_ids := agg.roles.map(it.id)
	role_names := agg.roles.map(it.name)

	data := dto.UserById{
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

// ===== 领域模型部分对象 (Entity/Value Object) =====
// DDD 中的 Part 是聚合的一部分，可以组合成 Aggregate

pub struct SysUserPart {
pub mut:
	id          string
	username    string
	nickname    string
	status      u8
	avatar      ?string
	description ?string
	home_path   string
	mobile      ?string
	email       ?string
	creator_id  ?string
	updater_id  ?string
	created_at  time.Time
	updated_at  time.Time
	deleted_at  ?time.Time
}

pub struct SysRolePart {
pub mut:
	id   string
	name string
}

// 聚合根
pub struct SysUserAggregate {
pub mut:
	user  SysUserPart
	roles []SysRolePart
}
