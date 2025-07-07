module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

@['/profile'; get]
fn (app &User) user_profile(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := user_profile_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success(200,'success', result))
}

fn user_profile_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['user_id'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() or {panic} }

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
