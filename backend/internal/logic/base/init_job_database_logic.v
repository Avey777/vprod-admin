module base

import veb
import log
import common.api { json_success_optparams }
import internal.structs { Context }
import internal.config { db_mysql }
import internal.structs.schema_job

@['/init/job/database'; get]
fn (app &Base) init_job(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql() // or { return ctx.json(json_error(1, 'failed to connect to database')) }
	defer {
		db.close()
	}

	sql db {
		create table schema_job.JobTask
		create table schema_job.JobTaskLog
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('数据库 init job success')

	return ctx.json(json_success_optparams(msg: 'job database init Successfull'))
}
