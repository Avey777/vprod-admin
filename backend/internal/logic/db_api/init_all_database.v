module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
import internal.structs.schema_sys
import internal.structs.schema_pay
import internal.structs.schema_mcms
import internal.structs.schema_job
import internal.structs.schema_fms

@['/init/all_database'; get]
fn (app &Base) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or {
		return ctx.json(json_error(500, 'Failed to acquire connection: ${err}'))
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
		create table schema_pay.PayRefund
		create table schema_pay.PayOrderExtension
		create table schema_pay.PayOrder
		create table schema_pay.PayDemoOrder
		create table schema_mcms.McmsSmsProvider
		create table schema_mcms.McmsSmsLog
		create table schema_mcms.McmsSiteNotification
		create table schema_mcms.McmsSiteInnerMsg
		create table schema_mcms.McmsSiteInnerCategory
		create table schema_mcms.McmsEmailProvider
		create table schema_mcms.McmsEmailLog
		create table schema_job.JobTask
		create table schema_job.JobTaskLog
		create table schema_fms.FmsStorageProvider
		create table schema_fms.FmsFileJoinTag
		create table schema_fms.FmsFile
		create table schema_fms.FmsFileTag
		create table schema_fms.FmsCloudFileCloudFileTag
		create table schema_fms.FmsCloudFile
		create table schema_fms.FmsCloudFileTag
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('数据库 init all success')

	return ctx.json(json_success_optparams(msg: 'all database init Successfull'))
}
