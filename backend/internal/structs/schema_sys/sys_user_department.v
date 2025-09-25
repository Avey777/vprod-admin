module schema_sys

@[comment: '用户部门关联表']
@[table: 'sys_user_department']
pub struct SysUserDepartment {
pub:
	user_id       string @[comment: '用户ID'; sql_type: 'CHAR(36)']
	department_id string @[comment: '部门ID'; sql_type: 'CHAR(36)']
}
