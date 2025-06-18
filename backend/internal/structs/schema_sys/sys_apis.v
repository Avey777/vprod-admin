module schema_sys

import time

@[table: 'sys_apis']
@[comment: 'API表']
pub struct SysApi {
pub:
	id           string  @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'VARCHAR(36)']
	path         string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API path | API 路径']
	description  ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API description | API 描述']
	api_group    string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'API group | API 分组']
	service_name string  @[default: '"Other"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Service name | 服务名称']
	method       string  @[default: '"POST"'; omitempty; sql_type: 'VARCHAR(32)'; zcomment: 'HTTP method | HTTP 请求类型']
	is_required  u8      @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomment: 'Whether is required | 是否必选']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
