module schema_core

import time

@[table: 'core_tenant_api']
@[comment: '租户API表']
pub struct CoreTenantApi {
pub:
	id           string  @[comment: 'UUID rand.uuid_v7()'; immutable; primary; sql: 'id'; sql_type: 'VARCHAR(36)']
	path         string  @[comment: 'API path | API 路径'; omitempty; sql_type: 'VARCHAR(255)']
	description  ?string @[comment: 'API description | API 描述'; omitempty; sql_type: 'VARCHAR(255)']
	api_group    string  @[comment: 'API group | API 分组'; omitempty; sql_type: 'VARCHAR(255)']
	service_name string  @[comment: 'Service name | 服务名称'; default: '"tenant"'; omitempty; sql_type: 'VARCHAR(255)']
	method       string  @[comment: 'HTTP method | HTTP 请求类型'; default: '"POST"'; omitempty; sql_type: 'VARCHAR(32)']
	is_required  u8      @[comment: 'Whether is required | 是否必选,，0：否，1：是'; default: 0; omitempty; sql_type: 'tinyint(1)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
