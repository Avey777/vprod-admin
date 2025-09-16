module schema_core

import time

@[comment: '应用表:全局应用供租户订阅']
@[table: 'core_applications']
pub struct CoreApplication {
pub:
	id            string @[comment: '应用ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	project_id    string @[comment: '所属项目ID'; primary; required; sql_type: 'CHAR(36)']
	name          string @[comment: '应用名称'; primary; required; sql_type: 'VARCHAR(100)']
	logo          string @[comment: '应用Logo'; omitempty; sql_type: 'VARCHAR(255)']
	homepage_path string @[comment: '应用主页Path'; omitempty; sql_type: 'VARCHAR(500)']
	description   string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(500)']
	status        u8     @[comment: '应用状态, 0:active, 1:inactive'; default: 0; sql_type: 'VARCHAR(20)']

	updater_id ?string    @[comment: 'sys 修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: 'sys 创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
