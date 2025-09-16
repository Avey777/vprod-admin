module schema_core

import time

@[comment: '租户角色菜单关系表']
@[table: 'core_roles_menus']
pub struct CoreRolesMenus {
pub:
	role_id string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	menu_id string @[comment: '菜单ID'; omitempty; required; sql_type: 'CHAR(36)']
}
