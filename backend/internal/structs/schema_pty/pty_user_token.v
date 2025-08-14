/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

import time

@[comment: '外部用户Token表']
@[table: 'pty_user_token']
pub struct PtyUserToken {
pub:
	id         string    @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomment: ' UUID']
	user_id    string    @[omitempty; sql: 'user_id'; sql_type: 'CHAR(36)'; zcomment: ' User`s UUID | 用户的UUID']
	username   string    @[default: '"unknown"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Username | 用户名']
	token      string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Token string | Token 字符串']
	source     string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Log in source such as GitHub | Token 来源 （本地为core, 第三方如github等）']
	expired_at time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomment: ' Expire time | 过期时间']
	status     u8        @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
