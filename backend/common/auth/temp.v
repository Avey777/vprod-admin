module main

struct RBAC {
mut:
	user_roles      map[string][]string     // 用户 -> [team:role]
	roles           map[string]Role         // 角色存储
	app_permissions map[string][]Permission // 键: team:role:app:portal -> 权限列表
}

struct Permission {
	portal   string // 新增门户字段
	resource string
	action   string
}

struct FullPermission {
	team     string
	role     string
	app      string
	portal   string // 新增门户字段
	resource string
	action   string
}

struct Role {
	id          string
	name        string
	description string
}

pub fn new_rbac() &RBAC {
	return &RBAC{
		user_roles:      map[string][]string{}
		roles:           map[string]Role{}
		app_permissions: map[string][]Permission{}
	}
}

// 创建角色
pub fn (mut r RBAC) create_role(id string, name string, description string) {
	r.roles[id] = Role{
		id:          id
		name:        name
		description: description
	}
}

// 获取角色
pub fn (r &RBAC) get_role(role_id string) ?Role {
	return r.roles[role_id] or { error('角色不存在') }
}

// 获取所有角色
pub fn (r &RBAC) get_all_roles() []Role {
	mut result := []Role{}
	for _, role in r.roles {
		result << role
	}
	return result
}

// 添加角色权限（新增门户参数）
pub fn (mut r RBAC) add_permission(team string, role string, app string, portal string, resource string, action string) {
	if role !in r.roles {
		eprintln('警告: 角色 "${role}" 尚未创建，自动创建基础角色')
		r.create_role(role, role, '自动创建的基础角色')
	}

	// 键格式: team:role:app:portal
	key := '${team}:${role}:${app}:${portal}'
	perm := Permission{portal, resource, action}

	// 检查权限是否已存在
	mut perms := r.app_permissions[key] or { []Permission{} }
	mut exists := false
	for p in perms {
		if p.portal == portal && p.resource == resource && p.action == action {
			exists = true
			break
		}
	}

	if !exists {
		perms << perm
		r.app_permissions[key] = perms
	}
}

// 分配用户角色
pub fn (mut r RBAC) assign_role(user string, team string, role string) {
	if role !in r.roles {
		eprintln('警告: 角色 "${role}" 尚未创建，自动创建基础角色')
		r.create_role(role, role, '自动创建的基础角色')
	}

	key := '${team}:${role}'

	if roles := r.user_roles[user] {
		for rk in roles {
			if rk == key {
				return
			}
		}
		r.user_roles[user] << key
	} else {
		r.user_roles[user] = [key]
	}
}

// 获取用户的角色列表
pub fn (r &RBAC) get_user_roles(user string) []RoleInfo {
	mut result := []RoleInfo{}
	user_roles := r.user_roles[user] or { return result }

	for role_key in user_roles {
		parts := role_key.split(':')
		if parts.len != 2 {
			continue
		}
		team := parts[0]
		role_id := parts[1]

		if role := r.roles[role_id] {
			result << RoleInfo{
				team: team
				role: role
			}
		}
	}
	return result
}

struct RoleInfo {
	team string
	role Role
}

// 权限检查（新增门户参数）
pub fn (r &RBAC) check(user string, team string, role string, app string, portal string, resource string, action string) bool {
	// 检查用户是否在指定团队拥有该角色
	user_role_key := '${team}:${role}'
	user_roles := r.user_roles[user] or { return false }
	mut has_role := false
	for ur in user_roles {
		if ur == user_role_key {
			has_role = true
			break
		}
	}
	if !has_role {
		return false
	}

	// 检查角色在指定应用和门户是否有权限
	perm_key := '${team}:${role}:${app}:${portal}'
	perms := r.app_permissions[perm_key] or { return false }

	for perm in perms {
		if perm.resource == resource && perm.action == action {
			return true
		}
	}
	return false
}

// 获取所有权限
pub fn (r &RBAC) get_permissions(user string) []FullPermission {
	mut all_perms := []FullPermission{}
	user_roles := r.user_roles[user] or { return all_perms }

	for role_key in user_roles {
		parts := role_key.split(':')
		if parts.len != 2 {
			continue
		}
		team := parts[0]
		role_id := parts[1]

		// 获取该角色的所有应用权限
		for key, perms in r.app_permissions {
			key_parts := key.split(':')
			if key_parts.len != 4 || key_parts[0] != team || key_parts[1] != role_id {
				continue
			}
			app := key_parts[2]
			portal := key_parts[3]

			for perm in perms {
				all_perms << FullPermission{
					team:     team
					role:     role_id
					app:      app
					portal:   portal
					resource: perm.resource
					action:   perm.action
				}
			}
		}
	}
	return all_perms
}

// 获取团队权限
pub fn (r &RBAC) get_team_permissions(user string, team string) []FullPermission {
	mut team_perms := []FullPermission{}
	perms := r.get_permissions(user)

	for perm in perms {
		if perm.team == team {
			team_perms << perm
		}
	}
	return team_perms
}

// 获取角色权限
pub fn (r &RBAC) get_role_permissions(team string, role string) []FullPermission {
	mut role_perms := []FullPermission{}

	// 获取该角色的所有应用权限
	for key, perms in r.app_permissions {
		key_parts := key.split(':')
		if key_parts.len != 4 || key_parts[0] != team || key_parts[1] != role {
			continue
		}
		app := key_parts[2]
		portal := key_parts[3]

		for perm in perms {
			role_perms << FullPermission{
				team:     team
				role:     role
				app:      app
				portal:   portal
				resource: perm.resource
				action:   perm.action
			}
		}
	}
	return role_perms
}

// 新增：获取应用权限
pub fn (r &RBAC) get_app_permissions(team string, app string) []FullPermission {
	mut app_perms := []FullPermission{}

	for key, perms in r.app_permissions {
		key_parts := key.split(':')
		if key_parts.len != 4 || key_parts[0] != team || key_parts[2] != app {
			continue
		}
		role := key_parts[1]
		portal := key_parts[3]

		for perm in perms {
			app_perms << FullPermission{
				team:     team
				role:     role
				app:      app
				portal:   portal
				resource: perm.resource
				action:   perm.action
			}
		}
	}
	return app_perms
}

// 新增：获取门户权限
pub fn (r &RBAC) get_portal_permissions(team string, app string, portal string) []FullPermission {
	mut portal_perms := []FullPermission{}

	for key, perms in r.app_permissions {
		key_parts := key.split(':')
		if key_parts.len != 4 || key_parts[0] != team || key_parts[2] != app
			|| key_parts[3] != portal {
			continue
		}
		role := key_parts[1]

		for perm in perms {
			portal_perms << FullPermission{
				team:     team
				role:     role
				app:      app
				portal:   portal
				resource: perm.resource
				action:   perm.action
			}
		}
	}
	return portal_perms
}

fn main() {
	mut auth := new_rbac()

	// 创建角色
	auth.create_role('admin', '管理员', '具有完全访问权限')
	auth.create_role('editor', '编辑者', '可以创建和编辑内容')
	auth.create_role('viewer', '查看者', '只能查看内容')
	auth.create_role('merchant', '商家', '管理商家相关功能')

	// 添加权限（新增门户参数）
	// 管理门户权限
	auth.add_permission('teamA', 'admin', 'ecommerce', 'management', 'dashboard', 'view')
	auth.add_permission('teamA', 'admin', 'ecommerce', 'management', 'settings', 'edit')

	// 商家门户权限
	auth.add_permission('teamA', 'merchant', 'ecommerce', 'merchant', 'products', 'manage')
	auth.add_permission('teamA', 'merchant', 'ecommerce', 'merchant', 'orders', 'view')
	auth.add_permission('teamA', 'merchant', 'ecommerce', 'merchant', 'reports', 'export')

	// 会员门户权限
	auth.add_permission('teamB', 'viewer', 'ecommerce', 'member', 'profile', 'view')
	auth.add_permission('teamB', 'editor', 'ecommerce', 'member', 'profile', 'edit')
	auth.add_permission('teamB', 'editor', 'ecommerce', 'member', 'preferences', 'update')

	// 分配角色
	auth.assign_role('alice', 'teamA', 'admin')
	auth.assign_role('alice', 'teamA', 'merchant')
	auth.assign_role('bob', 'teamB', 'editor')
	auth.assign_role('carol', 'teamB', 'viewer')

	// 获取用户角色
	println('\nAlice的角色:')
	roles := auth.get_user_roles('alice')
	for role_info in roles {
		println('团队 ${role_info.team}: ${role_info.role.name} (${role_info.role.description})')
	}

	// 获取所有权限
	println('\nAlice的所有权限:')
	all_perms := auth.get_permissions('alice')
	for perm in all_perms {
		println('${perm.team}.${perm.role}.${perm.app}.${perm.portal}: ${perm.resource} -> ${perm.action}')
	}

	// 获取团队权限
	println('\nAlice在teamA的权限:')
	team_perms := auth.get_team_permissions('alice', 'teamA')
	for perm in team_perms {
		println('${perm.app}.${perm.portal}: ${perm.resource} -> ${perm.action}')
	}

	// 获取角色权限
	println('\nTeamA商家权限:')
	role_perms := auth.get_role_permissions('teamA', 'merchant')
	for perm in role_perms {
		println('${perm.app}.${perm.portal}: ${perm.resource} -> ${perm.action}')
	}

	// 获取应用权限
	println('\nTeamA电商应用权限:')
	app_perms := auth.get_app_permissions('teamA', 'ecommerce')
	for perm in app_perms {
		println('${perm.portal}.${perm.role}: ${perm.resource} -> ${perm.action}')
	}

	// 获取门户权限
	println('\n电商应用商家门户权限:')
	portal_perms := auth.get_portal_permissions('teamA', 'ecommerce', 'merchant')
	for perm in portal_perms {
		println('${perm.role}: ${perm.resource} -> ${perm.action}')
	}

	// 权限检查
	println('\n权限检查:')
	println('Alice在管理门户能否编辑设置? ' +
		auth.check('alice', 'teamA', 'admin', 'ecommerce', 'management', 'settings', 'edit').str())
	println('Alice在商家门户能否管理产品? ' +
		auth.check('alice', 'teamA', 'merchant', 'ecommerce', 'merchant', 'products', 'manage').str())
	println('Bob在会员门户能否编辑个人资料? ' +
		auth.check('bob', 'teamB', 'editor', 'ecommerce', 'member', 'profile', 'edit').str())
}
