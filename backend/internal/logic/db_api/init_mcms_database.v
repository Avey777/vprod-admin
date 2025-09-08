module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
import internal.structs.schema_mcms

@['/init/init_mcms'; get]
pub fn (app &Base) init_mcms(mut ctx Context) veb.Result {
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
		create table schema_mcms.McmsSmsProvider
		create table schema_mcms.McmsSmsLog
		create table schema_mcms.McmsSiteNotification
		create table schema_mcms.McmsSiteInnerMsg
		create table schema_mcms.McmsSiteInnerCategory
		create table schema_mcms.McmsEmailProvider
		create table schema_mcms.McmsEmailLog
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('Database init_mcms success')

	return ctx.json(json_success_optparams(message: 'mcms database init Successfull'))
}
