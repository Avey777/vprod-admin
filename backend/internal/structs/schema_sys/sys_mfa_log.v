module schema_sys

import time

@[comment: '认证发送日志: SMS/Email']
@[table: 'sys_mfa_log']
pub struct SysMFAlog {
pub:
	id            string @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	verify_source string @[comment: 'Verify source | 验证源:手机号/邮箱号/'; sql_type: 'VARCHAR(255)']
	method        string @[comment: 'Configuration method |  方法: SMS/Email'; sql_type: 'VARCHAR(255)']
	code          string @[comment: 'Attempt code |  验证码'; sql_type: 'VARCHAR(255)']
	status        u8     @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	// updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; comment: '修改者ID']
	// updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; comment: 'Update Time | 修改日期']
	creator_id ?string   @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	// del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; comment: '删除标记，0：未删除，1：已删除']
	// deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; comment: 'Delete Time | 删除日期']
}
