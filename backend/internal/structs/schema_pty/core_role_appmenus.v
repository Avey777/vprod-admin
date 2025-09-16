module schema_core

import time

@[comment: '租户角色和应用菜单关系表']
@[table: 'core_role_appmenus']
pub struct CoreRoleAppMenus {
pub:
	role_id             string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	application_menu_id string @[comment: '应用菜单ID'; omitempty; required; sql_type: 'CHAR(36)']
}
