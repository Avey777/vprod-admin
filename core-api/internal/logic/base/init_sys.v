module base

import veb
import log
import internal.structs { json_error, json_success_optparams }
import internal.config { db_mysql }
import internal.structs.schema

@['/init/database'; get]
fn (app &Base) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db := db_mysql() or { return ctx.json(json_error(1, 'failed to connect to database')) }

	sql db {
		create table schema.SysUser
		create table schema.SysUserRole
		create table schema.SysUserPosition
		create table schema.SysToken
		create table schema.SysRole
		create table schema.SysRoleMenu
		create table schema.SysPosition
		create table schema.SysOauthProvider
		create table schema.SysMenu
		create table schema.SysDictionaryDetail
		create table schema.SysDictionary
		create table schema.SysDepartment
		create table schema.SysConfiguration
		create table schema.SysCasbinRule
		create table schema.SysAPI
	} or { return ctx.text('error creating table ${err}') }

	return ctx.json(json_success_optparams(msg: 'sys database init Successfull'))
}
