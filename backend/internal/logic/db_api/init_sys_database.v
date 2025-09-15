module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
import internal.structs.schema_sys

@['/init/init_sys'; get]
pub fn (app &Base) init_sys(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or {
		return ctx.json(json_error(500, '获取的连接无效: ${err}'))
	}
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	sql db {
		create table schema_sys.SysUser
		create table schema_sys.SysUserRole
		create table schema_sys.SysUserPosition
		create table schema_sys.SysToken
		create table schema_sys.SysRole
		create table schema_sys.SysRoleMenu
		create table schema_sys.SysPosition
		create table schema_sys.SysOauthProvider
		create table schema_sys.SysMenu
		create table schema_sys.SysMFAlog
		create table schema_sys.SysDictionaryDetail
		create table schema_sys.SysDictionary
		create table schema_sys.SysDepartment
		create table schema_sys.SysConfiguration
		create table schema_sys.SysCasbinRule
		create table schema_sys.SysApi
	} or { return ctx.text('error creating table:  ${err}') }
	log.info('schema_sys init_sys success')

	sys_users := r"REPLACE INTO `sys_users`
	  VALUES ('00000000-0000-0000-0000-000000000001', 'admin', '$2a$10${E0E6oRFnroxrPrDkRwA5s.AEiHNThGMdcA4HwPC1CBmP38tCn3De2}', 'administrator', '所有者', '/dashboard', NULL, NULL, '/avatar', '11111111-0000-0000-0000-000000000000', 0, NULL, '2025-07-25 11:11:34', NULL, '2025-07-25 11:11:34', 0, NULL);"
	db.exec(sys_users) or { return ctx.json(json_error(500, '执行SQL失败: ${err}')) }
	log.info('sys_users init_sys_data success')

	department := r"REPLACE INTO `sys_departments`
	  VALUES ('11111111-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'root', NULL, NULL, NULL, 'Root Department ', 0, 'China', 'guangdong', 'shenzhen', NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-08-25 20:58:59', NULL, '2025-08-21 09:53:34', 0, NULL);"
	db.exec(department) or { return ctx.json(json_error(500, '执行SQL失败: ${err}')) }
	log.info('department init_sys_data success')

	roles := r"REPLACE INTO `sys_roles`
	  VALUES ('00000000-1111-0000-0000-000000000000', 'admin', '001', '/dashboard', NULL, 0, 1, NULL, 0, NULL, '2025-07-25 11:16:05', NULL, '2025-07-25 11:16:00', 0, NULL);"
	db.exec(roles) or { return ctx.json(json_error(500, '执行SQL失败: ${err}')) }
	log.info('role init_sys_data success')

	return ctx.json(json_success_optparams(message: 'sys database init Successfull'))
}
