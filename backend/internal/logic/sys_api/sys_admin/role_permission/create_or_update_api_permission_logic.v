module role_permission

import veb
import log
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/role_permission/update_api'; post]
fn (app &RolePermission) update_api_permission(mut ctx Context) veb.Result {
	log.debug('${@METHOD} ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateApiReq](ctx.req.data) or {
		return ctx.json(api.json_error_400('Invalid request body: ${err.msg()}'))
	}

	// 参数检查
	if req.role_id == '' {
		return ctx.json(api.json_error_400('Missing required fields: role_id '))
	}
	if req.api_ids.len == 0 {
		return ctx.json(api.json_error_400('api_ids cannot be empty'))
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
		delete from schema_sys.SysRoleApi where role_id == req.role_id
	} or {
		db.rollback() or {}
		return error('Failed to delete old role-api permissions: ${err}')
	}

	// Step 2: 插入新API权限
	for api_id in req.api_ids {
		new_perm := schema_sys.SysRoleApi{
			role_id: req.role_id
			api_id:  api_id
		}

		sql db {
			insert new_perm into schema_sys.SysRoleApi
		} or {
			db.rollback() or {}
			return error('Failed to insert api_id=${api_id}: ${err}')
		}
	}
	// ✅ 成功后提交事务
	db.commit() or {
		db.rollback() or {}
		return error('Failed to commit transaction: ${err}')
	}

	log.info('Updated ${req.api_ids.len} api permissions for role=${req.role_id}')
	return 'Role api permissions updated successfully'
}

struct UpdateApiReq {
	role_id string   @[json: 'role_id']
	api_ids []string @[json: 'api_ids']
}
