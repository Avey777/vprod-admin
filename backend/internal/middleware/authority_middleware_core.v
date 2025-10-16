module middleware

import veb
import common.jwt
import log
import internal.structs { Context }
import internal.structs.schema_core

// Core认证中间件
fn authority_jwt_verify_core(mut ctx Context) bool {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	secret := ctx.get_custom_header('secret') or { '' }
	log.debug(secret)

	tenant_id := ctx.get_custom_header('tenant_id') or { '' }
	log.debug(tenant_id)
	if tenant_id == '' {
		ctx.request_error('Missing or invalid tenant_id')
		return false
	}

	subapp_id := ctx.get_custom_header('subapp_id') or { '' }
	log.debug(subapp_id)

	auth_header := ctx.get_header(.authorization) or { '' }
	log.debug(auth_header)
	if auth_header.len == 0 || !auth_header.starts_with('Bearer ') {
		ctx.res.status_code = 401
		ctx.request_error('Missing or invalid authentication token')
		return false
	}
	req_token := auth_header.all_after('Bearer').trim_space()
	log.debug(req_token)

	verify := jwt.jwt_verify(secret, req_token)
	if verify == false {
		ctx.res.status_code = 401
		ctx.request_error('Authorization error')
		log.warn('Authorization error')
		return false
	}

	// >>>>> 验证用户权限 >>>>>
	is_allowed := authorize_and_check_api(mut ctx, req_token, tenant_id, subapp_id, ctx.req.url) or {
		ctx.res.status_code = 403
		ctx.request_error('Authorization failed: ${err}')
		return false
	}

	if !is_allowed {
		ctx.res.status_code = 403
		ctx.request_error("You don't have permission to perform this action")
		return false
	}
	// <<<<< 验证用户权限 <<<<<

	return true
}

// 查询数据库直接验证是否拥有访问权限
fn authorize_and_check_api(mut ctx Context, req_token string, tenant_id string, subapp_id string, req_path string) !bool {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	log.debug('tenant_id: ${tenant_id}, subapp_id: ${subapp_id}, req_path: ${req_path}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	// step1 验证 token -> 获取用户ID
	core_token := sql db {
		select from schema_core.CoreToken where token == req_token limit 1
	}!
	if core_token.len != 1 {
		return error('Token not found')
	}
	user_id := core_token[0].user_id
	log.debug('user_id: ${user_id}')

	// step2️ 验证该用户是否属于该租户
	core_member := sql db {
		select from schema_core.CoreTenantMember where tenant_id == tenant_id && member_id == user_id limit 1
	}!
	if core_member.len < 1 {
		return error('Tenant Member not found')
	}
	// owner直接放行
	if core_member[0].is_owner == 1 {
		log.debug('User is tenant owner -> allow all')
		return true
	}

	// step3 获取角色
	core_roles := sql db {
		select from schema_core.CoreRoleTenantMember where tenant_id == tenant_id
		&& member_id == user_id
	}!
	if core_roles.len < 1 {
		return error('No roles found for user')
	}
	role_ids := core_roles.map(it.role_id)
	log.debug('role_ids: ${role_ids}')

	// step4 先查出当前路径对应的 API id
	api_records := sql db {
		select from schema_core.CoreApi where path == req_path
	}!
	if api_records.len == 0 {
		return error('API path not found in registry')
	}
	api_ids := api_records.map(it.id)

	// step5 检查租户级 API 权限
	mut tenant_api := sql db {
		select from schema_core.CoreRoleApi where role_id in role_ids && source_type == 'tenant'
		&& api_id in api_ids
	}!
	if tenant_api.len > 0 {
		log.debug('Tenant-level API matched ✅')
		return true
	}

	// step6 检查子应用级 API 权限
	if subapp_id != '' {
		mut app_api := sql db {
			select from schema_core.CoreRoleApi where role_id in role_ids && source_type == 'app'
			&& source_id == subapp_id && api_id in api_ids
		}!
		if app_api.len > 0 {
			log.debug('Subapp-level API matched ✅')
			return true
		}
	}

	log.debug('Access denied for ${user_id} on ${req_path}')
	return false
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware_core() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify_core // 显式初始化 handler 字段
		after:   false                     // 请求处理前执行
	}
}
