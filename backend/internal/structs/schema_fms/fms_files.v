module schema_fms

import time

// 文件管理系统文件表
@[table: 'fms_files']
pub struct FmsFile {
pub:
	id        string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name      string @[omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; zcomments: 'File`s name | 文件名称']
	file_type u8     @[index: 'file_file_type'; omitempty; required; sql: 'file_type'; sql_type: 'tinyint unsigned'; zcomments: 'File`s type | 文件类型']
	size      u64    @[omitempty; required; sql: 'size'; sql_type: 'bigint unsigned'; zcomments: 'File`s size | 文件大小']
	path      string @[omitempty; required; sql: 'path'; sql_type: 'VARCHAR(255)'; zcomments: 'File`s path | 文件路径']
	user_id   string @[index: 'file_user_id'; omitempty; required; sql: 'user_id'; sql_type: 'VARCHAR(255)'; zcomments: 'User`s UUID | 用户的 UUID']
	md5       string @[omitempty; required; sql: 'md5'; sql_type: 'VARCHAR(255)'; zcomments: 'The md5 of the file | 文件的 md5']
	status    u8     @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
