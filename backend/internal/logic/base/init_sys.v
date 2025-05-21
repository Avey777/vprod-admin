module base

import veb
import log
import common.api { json_success_optparams }
import internal.structs { Context }
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs.pay
import internal.structs.mcms
import internal.structs.job
import internal.structs.fms

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
		create table pay.PayRefund
		create table pay.PayOrderExtension
		create table pay.PayOrder
		create table pay.PayDemoOrder
		create table mcms.McmsSmsProvider
		create table mcms.McmsSmsLog
		create table mcms.McmsSiteNotification
		create table mcms.McmsSiteInnerMsg
		create table mcms.McmsSiteInnerCategory
		create table mcms.McmsEmailProvider
		create table mcms.McmsEmailLog
		create table job.JobTask
		create table job.JobTaskLog
		create table fms.FmsStorageProvider
		create table fms.FmsFileJoinTag
		create table fms.FmsFile
		create table fms.FmsFileTag
		create table fms.FmsCloudFileCloudFileTag
		create table fms.FmsCloudFile
		create table fms.FmsCloudFileTag
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('数据库 init success')

	return ctx.json(json_success_optparams(msg: 'sys database init Successfull'))
}
