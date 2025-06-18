module schema_sys

import time

@[table: 'sys_dictionaries']
@[comment: '字典表']
pub struct SysDictionary {
pub:
	id     string  @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	title  string  @[sql_type: 'VARCHAR(255)'; zcomment: 'The title shown in the ui | 展示名称 （建议配合i18n）']
	name   string  @[sql_type: 'VARCHAR(255)'; unique; zcomment: 'The name of dictionary for search | 字典搜索名称']
	desc   ?string @[sql_type: 'VARCHAR(255)'; zcomment: 'The description of dictionary | 字典的描述']
	status u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
