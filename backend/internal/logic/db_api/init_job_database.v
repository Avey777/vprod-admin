module db_api

import veb
import log
import common.api { json_error, json_success_optparams }
import internal.structs { Context }
import internal.structs.schema_job

@['/init/job_database'; get]
fn (app &Base) init_job(mut ctx Context) veb.Result {
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
		create table schema_job.JobTask
		create table schema_job.JobTaskLog
	} or { return ctx.text('error creating table:  ${err}') }
	log.debug('数据库 init job success')

	return ctx.json(json_success_optparams(msg: 'job database init Successfull'))
}
