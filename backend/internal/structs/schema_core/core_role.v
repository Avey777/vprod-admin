module schema_core

@[table: 'core_tenant_role']
@[comment: '租户角色表']
pub struct CoreTenantRole {
pub:
	id          string @[comment: '租户角色ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; unique]
	tenant_id   string @[comment: '所属租户ID'; primary; required; sql_type: 'CHAR(36)']
	name        string @[comment: '角色名称'; primary; required; sql_type: 'VARCHAR(255)']
	description string @[comment: '角色描述'; primary; required; sql_type: 'VARCHAR(255)']
}
