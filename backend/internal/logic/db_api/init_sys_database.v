module db_api

import veb
import log
import common.api { json_success_optparams }
import internal.structs { Context }
import internal.config { db_mysql }
import internal.structs.schema_sys

@['/init/sys_database'; get]
fn (app &Base) init_sys(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql() // or { return ctx.json(json_error(1, 'failed to connect to database')) }
	defer {
		db.close() or {panic}
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
	log.debug('数据库 init sys success')

	return ctx.json(json_success_optparams(msg: 'sys database init Successfull'))
}
