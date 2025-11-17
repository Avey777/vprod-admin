// 根据租户ID和应用订阅ID,逐个设置租户角色的菜单权限
// step1 删除角色关联的租户的所有菜单权限
// step2 插入角色关联的租户的所有菜单权限

module role_permission

import veb
import log
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/tenant_role_permission/update_menu'; post]
fn (app &RolePermission) update_menu_permission(mut ctx Context) veb.Result {
	log.debug('${@METHOD} ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateMenuReq](ctx.req.data) or {
		return ctx.json(api.json_error_400('Invalid request body: ${err.msg()}'))
	}

	// 参数检查
	if req.role_id == '' || req.tenant_id == '' || req.source_id == '' || req.source_type == '' {
		return ctx.json(api.json_error_400('Missing required fields: tenant_id / role_id / source_type / source_id'))
	}
	if req.menu_ids.len == 0 {
		return ctx.json(api.json_error_400('menu_ids cannot be empty'))
	}

	// ✅ 正确的 V 语言错误处理写法
	mut result := update_menu_permission_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

// -------------------------------
// 核心逻辑：删除旧权限 + 插入新权限
// -------------------------------
fn update_menu_permission_resp(mut ctx Context, req UpdateMenuReq) !UpdateMenuResp {
	log.debug('${@METHOD} ${@MOD}.${@FILE_LINE}')

	mut db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	// ✅ 显式开启事务
	db.begin() or { return error('Failed to begin transaction: ${err}') }

	// Step 1: 删除旧数据
	sql db {
		delete from schema_core.CoreRoleMenu where role_id == req.role_id
		&& source_type == req.source_type && source_id == req.source_id
	} or {
		db.rollback() or {}
		return error('Failed to delete old role-menu permissions: ${err}')
	}

	// Step 2: 插入新菜单权限
	for menu_id in req.menu_ids {
		new_perm := schema_core.CoreRoleMenu{
			role_id:     req.role_id
			menu_id:     menu_id
			source_type: req.source_type
			source_id:   req.source_id
		}
		sql db {
			insert new_perm into schema_core.CoreRoleMenu
		} or {
			db.rollback() or {}
			return error('Failed to insert menu_id=${menu_id}: ${err}')
		}
	}
	// ✅ 成功后提交事务
	db.commit() or {
		db.rollback() or {}
		return error('Failed to commit transaction: ${err}')
	}

	log.info('Updated ${req.menu_ids.len} menu permissions for role=${req.role_id}')
	return UpdateMenuResp{
		msg: 'Role menu permissions updated successfully'
	}
}

struct UpdateMenuReq {
	tenant_id   string   @[json: 'tenant_id']
	role_id     string   @[json: 'role_id']
	menu_ids    []string @[json: 'menu_ids']
	source_type string   @[json: 'source_type']
	source_id   string   @[json: 'source_id']
}

struct UpdateMenuResp {
	msg string @[json: 'msg']
}
