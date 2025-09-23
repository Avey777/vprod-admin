module schema_sys

@[comment: '用户职位关联表']
@[table: 'sys_user_position']
pub struct SysUserPosition {
pub:
	user_id     string @[comment: '用户ID'; sql_type: 'CHAR(36)']
	position_id string @[comment: '职位ID'; sql_type: 'CHAR(36)']
}
