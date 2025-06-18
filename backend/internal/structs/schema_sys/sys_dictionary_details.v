module schema_sys

import time

@[table: 'sys_dictionary_details']
@[comment: '字典详情表']
pub struct SysDictionaryDetail {
pub:
	id            string @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	title         string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The title shown in the ui | 展示名称 （建议配合i18n）']
	key           string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'key | 键']
	value         string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'value | 值']
	dictionary_id string @[omitempty; sql_type: 'CHAR(36)'; zcomment: 'Dictionary ID | 字典ID']
	sort          u32    @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status        u8     @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
