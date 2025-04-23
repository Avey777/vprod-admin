module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/update_user_profile'; post]
fn (app &User) update_user_profile_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

	mut result := update_user_profile_resp(req) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

fn update_user_profile_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()
	avatar:= req.as_map()['avatar'] or { '' }.str()
	email:= req.as_map()['email'] or { '' }.str()
	mobile:= req.as_map()['mobile'] or { '' }.str()
	nickname:= req.as_map()['nickname'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema.SysUser](db)
	sys_user.set('id = ?', user_id)!
       	.set('avatar = ?', avatar)!
       	.set('email = ?', email)!
       	.set('mobile = ?', mobile)!
       	.set('nickname = ?', nickname)!
        .update()!

	return  map[string]Any{}
}
