module schema_core

import time

@[table: 'core_tenant_member']
@[comment: '租户成员表']
pub struct CoreTeamMember {
pub:
	tenant_id string   @[comment: 'Tenant ID | 租户ID'; immutable; sql: 'tenant_id'; sql_type: 'CHAR(36)']
	user_id   string   @[comment: 'User ID | 用户ID'; immutable; sql: 'user_id'; sql_type: 'CHAR(36)']
	role_id   []string @[comment: 'Role ID | 角色ID'; immutable; sql: 'role_id'; sql_type: 'CHAR(36)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
