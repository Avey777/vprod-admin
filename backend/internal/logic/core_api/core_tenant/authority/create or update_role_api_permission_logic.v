// 根据租户ID和应用订阅ID,逐个设置租户角色的api权限
// step1 删除角色关联的租户的所有api权限
// step1 插入角色关联的租户的所有api权限
module authority

import veb
import log
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/role_permission/update_api'; post]
fn (app &RolePermission) update_api_permission(mut ctx Context) veb.Result {
	log.debug('${@METHOD} ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateApiReq](ctx.req.data) or {
		return ctx.json(api.json_error_400('Invalid request body: ${err.msg()}'))
	}

	// 参数检查
	if req.role_id == '' || req.tenant_id == '' || req.source_id == '' || req.source_type == '' {
		return ctx.json(api.json_error_400('Missing required fields: tenant_id / role_id / source_type / source_id'))
	}
	if req.api_ids.len == 0 {
		return ctx.json(api.json_error_400('menu_ids cannot be empty'))
	}

	// ✅ 正确的 V 语言错误处理写法
	mut result := update_api__permission_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

// -------------------------------
// 核心逻辑：删除旧权限 + 插入新权限
// -------------------------------
fn update_api__permission_resp(mut ctx Context, req UpdateApiReq) !string {
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

	// Step 2: 插入新API权限
	for api_id in req.api_ids {
		new_perm := schema_core.CoreRoleApi{
			role_id:     req.role_id
			api_id:      api_id
			source_type: req.source_type
			source_id:   req.source_id
		}
		sql db {
			insert new_perm into schema_core.CoreRoleApi
		} or {
			db.rollback() or {}
			return error('Failed to insert menu_id=${api_id}: ${err}')
		}
	}
	// ✅ 成功后提交事务
	db.commit() or {
		db.rollback() or {}
		return error('Failed to commit transaction: ${err}')
	}

	log.info('Updated ${req.api_ids.len} menu permissions for role=${req.role_id}')
	return 'Role api permissions updated successfully'
}

struct UpdateApiReq {
	tenant_id   string   @[json: 'tenant_id']
	role_id     string   @[json: 'role_id']
	api_ids     []string @[json: 'menu_ids']
	source_type string   @[json: 'source_type']
	source_id   string   @[json: 'source_id']
}
