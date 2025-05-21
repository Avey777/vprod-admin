module fms

import time

// 云文件表
@[table: 'fms_cloud_files']
pub struct FmsCloudFile {
pub:
	id                           string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name                         string @[index: 'cloudfile_name'; omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; zcomments: 'The file`s name | 文件名']
	url                          string @[omitempty; required; sql: 'url'; sql_type: 'VARCHAR(255)'; zcomments: 'The file`s url | 文件地址']
	size                         u64    @[omitempty; required; sql: 'size'; sql_type: 'bigint unsigned'; zcomments: 'The file`s size | 文件大小']
	file_type                    u8     @[index: 'cloudfile_file_type'; omitempty; required; sql: 'file_type'; sql_type: 'tinyint unsigned'; zcomments: 'The file`s type | 文件类型']
	user_id                      string @[omitempty; required; sql: 'user_id'; sql_type: 'VARCHAR(255)'; zcomments: 'The user who upload the file | 上传用户的 ID']
	cloud_file_storage_providers ?u64   @[omitempty; sql: 'cloud_file_storage_providers'; sql_type: 'bigint unsigned'; zcomments: 'Reference to storage provider']
	status                       u8     @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint(1)'; zcomments: 'State true: normal false: ban | 状态 true 正常 false 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
