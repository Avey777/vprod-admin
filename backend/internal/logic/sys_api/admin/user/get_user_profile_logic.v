module user

import veb
import log
import orm
import x.json2
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/profile'; get]
fn (app &User) user_profile(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.decode[json2.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := user_profile_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn user_profile_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	user_id := req.as_map()['user_id'] or { '' }.str()

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	result := sys_user.select('id = ?', user_id)!.query()!
	dump(result)

	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['nickname'] = row.nickname
		data['avatar'] = row.avatar or { '' }
		data['mobile'] = row.mobile or { '' }
		data['email'] = row.email or { '' }

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
