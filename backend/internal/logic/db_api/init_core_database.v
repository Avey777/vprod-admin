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
		create table schema_core.CoreApplications
		create table schema_core.CoreApplicationMenus
		create table schema_core.CoreConnectors
		create table schema_core.CoreProjects
		create table schema_core.CoreRoleAppMenus
		create table schema_core.CoreRoleTenantMenus
		create table schema_core.CoreTenantRoles
		create table schema_core.CoreTenants
		create table schema_core.CoreTenantMember
		create table schema_core.CoreTenantMenus
		create table schema_core.CoreTenantSubscribeApplication
		create table schema_core.CoreToken
		create table schema_core.CoreUser
		create table schema_core.CoreUserConnectors
	} or { return ctx.text('error creating table:  ${err}') }
	log.info('schema_core init_core success')

	return ctx.json(json_success_optparams(message: 'core database init Successfull'))
}
