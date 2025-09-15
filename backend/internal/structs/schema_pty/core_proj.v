/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

import time

@[table: 'pty_projects']
@[comment: '项目表']  //
pub struct PtyProject {
pub:
	id                    string @[comment: '应用ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	app_owner             string @[comment: '应用所有者'; primary; required; sql_type: 'VARCHAR(100)']
	app_name              string @[comment: '应用名称'; primary; required; sql_type: 'VARCHAR(100)']
	created_time          string @[comment: '创建时间'; omitempty; sql_type: 'VARCHAR(100)']
	display_name          string @[comment: '显示名称'; omitempty; sql_type: 'VARCHAR(100)']
	logo                  string @[comment: '应用Logo'; omitempty; sql_type: 'VARCHAR(100)']
	homepage_url          string @[comment: '主页URL'; omitempty; sql_type: 'VARCHAR(100)']
	description           string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(100)']

	status string @[comment: '状态(active/inactive)'; default: '"active"'; sql_type: 'VARCHAR(20)']

	updater_id ?string    @[comment: 'sys 修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: 'sys 创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
