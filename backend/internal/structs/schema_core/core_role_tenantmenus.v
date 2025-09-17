module schema_core

import time

@[comment: '租户角色和租户菜单关系表']
@[table: 'core_role_tenantmenus']
pub struct CoreRoleTenantMenus {
pub:
	role_id        string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	tenant_menu_id string @[comment: '租户菜单ID'; omitempty; required; sql_type: 'CHAR(36)']
}
