module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
import internal.structs.schema_core

@['/init/init_core'; get]
pub fn (app &Base) init_core(mut ctx Context) veb.Result {
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
		create table schema_core.CoreApp
		create table schema_core.CoreAppClient
		create table schema_core.CoreConnector
		create table schema_core.CoreProject
		create table schema_core.CoreRole
		create table schema_core.CoreTenant
		create table schema_core.CoreTenantMember
		create table schema_core.CoreTenantMemberRole
		create table schema_core.CoreTenantSubApp
		create table schema_core.CoreToken
		create table schema_core.CoreUser
		create table schema_core.CoreUserConnector
	} or { return ctx.text('error creating table:  ${err}') }
	log.info('schema_core init_core success')

	return ctx.json(json_success_optparams(message: 'core database init Successfull'))
}
