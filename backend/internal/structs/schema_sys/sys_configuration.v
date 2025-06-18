module schema_sys

import time

@[table: 'sys_configurations']
@[comment: '配置表']
pub struct SysConfiguration {
pub:
	id       string  @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name     string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configurarion name | 配置名称']
	key      string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuration key | 配置的键名']
	value    string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuraion value | 配置的值']
	category string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuration category | 配置的分类']
	remark   ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Remark | 备注']
	sort     u32     @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status   u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
