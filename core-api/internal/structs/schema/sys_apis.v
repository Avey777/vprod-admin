module schema

import time

// API表
@[table: 'sys_apis']
pub struct SysAPI {
pub:
	id           string  @[immutable; primary; sql: 'id'; sql_type: 'VARCHAR(36)'; zcomments: 'UUID']
	path         string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API path | API 路径']
	description  ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API description | API 描述']
	api_group    string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API group | API 分组']
	service_name string  @[default: '\"Other\"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Service name | 服务名称']
	method       string  @[default: '\"POST\"'; omitempty; sql_type: 'VARCHAR(32)'; zcomment: 'HTTP method | HTTP 请求类型']
	is_required  u8      @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Whether is required | 是否必选']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
