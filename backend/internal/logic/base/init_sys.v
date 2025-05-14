module base

import veb
import log
import common.api { json_success_optparams }
import internal.structs { Context }
import internal.config { db_mysql }
import internal.structs.schema

@['/init/database'; get]
fn (app &Base) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql() // or { return ctx.json(json_error(1, 'failed to connect to database')) }
	defer {
		db.close()
	}

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
		create table schema.SysApi
		create table schema.PayRefund
		create table schema.PayOrderExtension
		create table schema.PayOrder
		create table schema.PayDemoOrder
		create table schema.McmsSmsProvider
		create table schema.McmsSmsLog
		create table schema.McmsSiteNotification
		create table schema.McmsSiteInnerMsg
		create table schema.McmsSiteInnerCategory
		create table schema.McmsEmailProvider
		create table schema.McmsEmailLog
		create table schema.JobTask
		create table schema.JobTaskLog
		create table schema.FmsStorageProvider
		create table schema.FmsFileJoinTag
		create table schema.FmsFile
		create table schema.FmsFileTag
		create table schema.FmsCloudFileCloudFileTag
		create table schema.FmsCloudFile
		create table schema.FmsCloudFileTag
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('数据库 init success')

	return ctx.json(json_success_optparams(msg: 'sys database init Successfull'))
}
