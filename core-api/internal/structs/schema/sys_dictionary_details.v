module schema

import time

// 字典详情表
@[table: 'sys_dictionary_details']
pub struct SysDictionaryDetail {
pub:
	id            string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	title         string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The title shown in the ui | 展示名称 （建议配合i18n）']
	key           string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'key | 键']
	value         string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'value | 值']
	dictionary_id string @[omitempty; sql_type: 'CHAR(36)'; zcomment: 'Dictionary ID | 字典ID']
	sort          u32    @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status        u8     @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
