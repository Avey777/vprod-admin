module schema_core

@[comment: '租户角色和租户API关系表']
@[table: 'core_role_tenantapi']
pub struct CoreRoleTenantApi {
pub:
	role_id       string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	tenant_api_id string @[comment: '租户 Api ID'; omitempty; required; sql_type: 'CHAR(36)']
}
