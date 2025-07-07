module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
// import internal.config { db_mysql }
import internal.structs.schema_sys

@['/init/sys_database'; get]
fn (app &Base) init_sys(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// mut db := db_mysql() // or { return ctx.json(json_error(1, 'failed to connect to database')) }
	// defer {
	// 	db.close() or {panic}
	// }

	db, conn := ctx.dbpool.acquire() or {
		log.debug('ctx.dbpool.acquire(): ${err}')
		return ctx.json(json_error(500, '获取连接失败: ${err}'))
	}
	defer {
		ctx.dbpool.release(conn) or { log.warn('${@LOCATION}') } // or { return ctx.json(json_error(500,'释放连接失败: ${err}')) }
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
	log.warn('数据库 init sys success')

	return ctx.json(json_success_optparams(msg: 'sys database init Successfull'))
}

@['/init']
fn (mut app Base) get_user(mut ctx Context) veb.Result {
	log.debug('Executing DDL:0')
	_, conn := ctx.dbpool.acquire() or { return ctx.text('获取连接失败: ${err}') }
	log.debug('Executing DDL:1')
	defer {
		ctx.dbpool.release(conn) or { eprintln('释放连接失败: ${err}') }
	}
	log.debug('Executing DDL:1')
	// rows := sql db {
	// 	select from schema_sys.SysUser
	// } or { panic(err) }

	return ctx.text('rows.str()')
}
