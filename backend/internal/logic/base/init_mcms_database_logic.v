module base

import veb
import log
import common.api { json_success_optparams }
import internal.structs { Context }
import internal.config { db_mysql }
import internal.structs.schema_mcms

@['/init/mcms/database'; get]
fn (app &Base) init_mcms(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql() // or { return ctx.json(json_error(1, 'failed to connect to database')) }
	defer {
		db.close()
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
	log.debug('数据库 init mcms success')

	return ctx.json(json_success_optparams(msg: 'mcms database init Successfull'))
}
