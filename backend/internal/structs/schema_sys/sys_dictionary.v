module schema_sys

import time

// 字典表
@[table: 'sys_dictionaries']
pub struct SysDictionary {
pub:
	id     string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	title  string  @[sql_type: 'VARCHAR(255)'; zcomment: 'The title shown in the ui | 展示名称 （建议配合i18n）']
	name   string  @[sql_type: 'VARCHAR(255)'; unique; zcomment: 'The name of dictionary for search | 字典搜索名称']
	desc   ?string @[sql_type: 'VARCHAR(255)'; zcomment: 'The description of dictionary | 字典的描述']
	status u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
