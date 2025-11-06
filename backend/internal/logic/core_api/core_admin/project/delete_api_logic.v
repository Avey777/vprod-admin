module project

import veb
import log
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Delete api | 删除Project
@['/delete_api'; post]
fn (app &Project) delete_project(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[DeleteCoreProjectReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := delete_project_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn delete_project_resp(mut ctx Context, req DeleteCoreProjectReq) !DeleteCoreProjectResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	sql db {
		delete from schema_core.CoreProject where id == req.id
	} or { return error('Failed to delete project: ${err}') }

	return DeleteCoreProjectResp{
		msg: 'API deleted successfully'
	}
}

struct DeleteCoreProjectReq {
	id string @[json: 'id'; required]
}

struct DeleteCoreProjectResp {
	msg string
}
