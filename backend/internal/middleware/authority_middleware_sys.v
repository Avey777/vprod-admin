module middleware

import veb
import internal.structs { Context }
import internal.structs.schema_sys
import common.jwt
import log

//认证中间件
fn authority_jwt_verify(mut ctx Context) bool {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	secret := ctx.get_custom_header('secret') or { '' }
	log.debug(secret)

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
	user_api_list := get_userapilist_from_token(mut ctx, req_token) or { return false }
	if !user_api_list.contains('*') && ctx.req.url !in user_api_list {
		ctx.res.status_code = 403
		ctx.request_error("You don't have permission to perform this action")
		return false
	}
	// <<<<< 验证用户权限 <<<<<

	return true
}

// 查询数据库来验证 token 并获取用户api信息
fn get_userapilist_from_token(mut ctx Context, req_token string) ![]string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 详细的连接池检查
	if isnil(ctx.dbpool) {
		log.error('FATAL: ctx.dbpool is nil!')
		return error('Database pool not initialized')
	}

	log.debug('dbpool type: ${typeof(ctx.dbpool).name}')
	log.debug('Attempting to acquire connection...')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}
	sys_token := sql db {
		select from schema_sys.SysToken where token == req_token limit 1
	}!
	if sys_token.len != 1 {
		return error('Token not found')
	}
	log.debug('user_id: ${sys_token[0].user_id}')

	// >>>>>> 检查是否是root用户，如果是可以跳过权限查询 >>>>>>
	sys_user := sql db {
		select from schema_sys.SysUser where id == sys_token[0].user_id limit 1
	}!
	if sys_user.len != 1 {
		return error('User not found')
	}
	if sys_user[0].is_root == 1 {
		log.debug('is_root: ${sys_user[0].is_root},true')
		return ['*'] // 使用 '*' 标记表示拥有所有权限
	}
	log.debug('is_root: ${sys_user[0].is_root},false')
	// <<<<< 检查是否是root用户，如果是可以跳过权限查询 <<<<<

	sys_user_role := sql db {
		select from schema_sys.SysUserRole where user_id == sys_user[0].id
	}!
	if sys_user_role.len < 1 {
		return error('User role not found')
	}
	mut role_id_list := sys_user_role.map(it.role_id)
	log.debug('role_id: ${role_id_list}')

	sys_role_api := sql db {
		select from schema_sys.SysRoleApi where role_id in role_id_list
	}!
	if sys_role_api.len < 1 {
		return error('Role api not found')
	}
	mut api_id_list := sys_role_api.map(it.api_id)
	log.debug('api_id: ${api_id_list}')

	sys_api := sql db {
		select from schema_sys.SysApi where id in api_id_list || is_required == 1
	}!
	if sys_api.len < 1 {
		return error('Api not found')
	}
	mut user_api_list := sys_api.map(it.path)
	log.debug('api_list: ${user_api_list}')

	return user_api_list
}

// 初始化中间件并设置 handler ,并返回中间件选项
pub fn authority_middleware() veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: authority_jwt_verify // 显式初始化 handler 字段
		after:   false                // 请求处理前执行
	}
}
