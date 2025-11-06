module project

import veb
import log
import time
import x.json2 as json
import rand
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Create api | 创建Project
@['/create_api'; post]
fn (app &Project) create_api(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateCoreProjectReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_project_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_project_resp(mut ctx Context, req CreateCoreProjectReq) !CreateCoreProjectResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	time_now := time.now()
	data := schema_core.CoreProject{
		id:           rand.uuid_v7()
		name:         req.name
		display_name: req.display_name or { '' }
		logo:         req.logo
		description:  req.description or { '' }
		created_at:   time_now
		updated_at:   time_now
	}

	sql db {
		insert data into schema_core.CoreProject
	} or { return error('Failed to insert project: ${err}') }

	return CreateCoreProjectResp{
		msg: 'API created successfully'
	}
}

struct CreateCoreProjectReq {
	name         string  @[json: 'name'; required]
	display_name ?string @[json: 'display_name']
	logo         string  @[json: 'logo']
	description  ?string @[json: 'description']
}

struct CreateCoreProjectResp {
	msg string
}
