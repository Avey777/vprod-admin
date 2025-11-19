module project

import veb
import log
import orm
import time
import x.json2 as json
import structs.schema_core
import common.api
import structs { Context }

// Update api ||更新Project
@['/update_api'; post]
fn (app &Project) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateCoreProjectReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_api_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_api_resp(mut ctx Context, req UpdateCoreProjectReq) !UpdateCoreProjectResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_api := orm.new_query[schema_core.CoreProject](db)

	sys_api.set('name = ?', req.name)!
		.set('description = ?', req.description or { '' })!
		.set('display_name = ?', req.display_name or { '' })!
		.set('logo = ?', req.logo)!
		.set('updated_at = ?', time.now())!
		.where('id = ?', req.id)!
		.update()!

	// sql db {
	// 	update schema_core.CoreProject set name = req.name, description = req.description,
	// 	display_name = req.display_name, logo = req.logo, updated_at = time.now() where id == req.id
	// } or { return error('Failed to update project: ${err}') }

	return UpdateCoreProjectResp{
		msg: 'API updated successfully'
	}
}

struct UpdateCoreProjectReq {
	id           string  @[json: 'id'; required]
	name         string  @[json: 'name']
	display_name ?string @[json: 'display_name']
	logo         string  @[json: 'logo']
	description  ?string @[json: 'description']
}

struct UpdateCoreProjectResp {
	msg string
}
