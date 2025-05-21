module fms

import time

// 云文件标签表
@[table: 'fms_cloud_file_tags']
pub struct FmsCloudFileTag {
pub:
	id     string  @[primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name   string  @[index: 'cloudfiletag_name'; omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; zcomments: 'CloudFileTag`s name | 标签名称']
	remark ?string @[omitempty; sql: 'remark'; sql_type: 'VARCHAR(255)'; zcomments: 'The remark of tag | 标签的备注']
	status u8      @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
