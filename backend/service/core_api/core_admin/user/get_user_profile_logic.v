module user

import veb
import log
import orm
import x.json2 as json
import structs.schema_core
import common.api
import structs { Context }

@['/profile'; get]
fn (app &User) user_profile(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UserProfileReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := user_profile_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn user_profile_resp(mut ctx Context, req UserProfileReq) !UserProfileResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_user := orm.new_query[schema_core.CoreUser](db)
	result := core_user.select('id = ?', req.user_id)!.query()!
	dump(result)

	if result.len == 0 {
		return error('User not found')
	}

	row := result[0]
	data := UserProfileResp{
		nickname: row.nickname
		avatar:   row.avatar or { '' }
		email:    row.email or { '' }
	}

	return data
}

struct UserProfileReq {
	user_id string @[json: 'user_id']
}

struct UserProfileResp {
	nickname string @[json: 'nickname']
	avatar   string @[json: 'avatar']
	email    string @[json: 'email']
}
