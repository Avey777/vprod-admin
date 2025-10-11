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
	user_api_map := authorize_and_fetch_apis(mut ctx, req_token, tenant_id) or { return false }

	if subapp_id != '' && subapp_id !in user_api_map.keys() {
		if user_api_map['*'] != ['*'] && ctx.req.url in user_api_map['tenant'] {
			return true
		}
		ctx.res.status_code = 403
		ctx.request_error("You don't have permission to perform this action")
		return false
	}

	if ctx.req.url !in user_api_map[subapp_id] {
		ctx.res.status_code = 403
		ctx.request_error("You don't have permission to perform this action")
		return false
	}
	// <<<<< 验证用户权限 <<<<<

	return true
}

// 查询数据库来验证 token 并获取用户api信息
fn authorize_and_fetch_apis(mut ctx Context, req_token string, tenantid string) !map[string][]string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}
	// 验证token并获取用户ID
	core_token := sql db {
		select from schema_core.CoreToken where token == req_token limit 1
	}!
	if core_token.len != 1 {
		return error('Token not found')
	}
	log.debug('user_id: ${core_token[0].user_id}')

	//* >>>>>> 检查是否是租户 owser，如果是可以跳过权限查询 >>>>>> */
	core_tenant_member := sql db {
		select from schema_core.CoreTenantMember where tenant_id == tenantid
		&& member_id == core_token[0].user_id limit 1
	}!
	if core_tenant_member.len != 1 {
		return error('Tenant Member not found')
	}
	if core_tenant_member[0].is_owner == 1 {
		log.debug('is_owner: ${core_tenant_member[0].is_owner},true')
		return {
			'*': ['*']
		} // 使用 '*' 标记表示拥有所有权限
	}
	log.debug('is_owner: ${core_tenant_member[0].is_owner},false')
	//* <<<<< 检查是否是租户 owser，如果是可以跳过权限查询 <<<<< */

	// 获取用户角色
	core_member_role := sql db {
		select from schema_core.CoreTenantMemberRole where tenant_id == tenantid
		&& member_id == core_token[0].user_id
	}!
	if core_member_role.len < 1 {
		return error('Tenant Member role not found')
	}
	mut tenant_role_id_list := core_member_role.map(it.role_id)
	log.debug('role_id: ${tenant_role_id_list}')

	// 获取角色关联的API权限（使用IN查询避免多次查询）
	role_tenant_api := sql db {
		select from schema_core.CoreRoleTenantApi where role_id in tenant_role_id_list
	}! //角色关联 租户Api
	role_subapp_api := sql db {
		select from schema_core.CoreRoleSubAppApi where role_id in tenant_role_id_list
	}! //角色关联 订阅应用Api
	if role_tenant_api.len < 1 && role_subapp_api.len < 1 {
		return error('Role api not found')
	}

	// 批量处理租户API
	mut tenant_api_id_list := role_tenant_api.map(it.tenant_api_id)
	log.debug('api_id: ${tenant_api_id_list}')
	tenant_api := sql db {
		select from schema_core.CoreTenantApi where id in tenant_api_id_list || is_required == 1
	}!
	// 批量处理订阅应用API
	mut app_api_id_list := role_subapp_api.map(it.app_api_id)
	subapp_api := sql db {
		select from schema_core.CoreAppApi where id in app_api_id_list || is_required == 1
	}!

	if tenant_api.len < 1 || subapp_api.len < 1 {
		return error('Tenant or SubApp Api not found')
	}

	// 处理订阅权限数据
	mut api_path_map := map[string]string{}
	for i in subapp_api {
		api_path_map[i.id] = i.path
	}

	mut map_subapp_api := map[string][]string{}
	for item in role_subapp_api {
		if found_path := api_path_map[item.app_api_id] {
			map_subapp_api[item.tenant_subapp_id] << found_path
		}
	}
	log.debug('map_subapp_api: ${map_subapp_api}')

	// 处理租户Api数据
	mut tenant_api_list := tenant_api.map(it.path)
	log.debug('api_list: ${tenant_api_list}')

	// 合并租户和订阅应用的Api数据
	map_subapp_api['tenant'] << tenant_api_list
	return map_subapp_api
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware_core() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify_core // 显式初始化 handler 字段
		after:   false                     // 请求处理前执行
	}
}
