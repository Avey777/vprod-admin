module schema

import time

// 配置表
@[table: 'sys_configurations']
pub struct SysConfiguration {
pub:
	id       string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name     string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configurarion name | 配置名称']
	key      string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuration key | 配置的键名']
	value    string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuraion value | 配置的值']
	category string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Configuration category | 配置的分类']
	remark   ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Remark | 备注']
	sort     u32     @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status   u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
