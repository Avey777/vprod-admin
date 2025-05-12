module schema

// 用户职位关联表
@[table: 'sys_user_positions']
pub struct SysUserPosition {
pub:
	user_id     string @[sql_type: 'CHAR(36)'; zcomments: '用户ID']
	position_id string @[sql_type: 'CHAR(36)'; zcomments: '职位ID']
}
