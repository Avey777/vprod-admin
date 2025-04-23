module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Change Password | 修改密码
@['/change_password'; post]
fn (app &User) change_password(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := change_password_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn change_password_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()
	new_password := req.as_map()['newPassword'] or { '' }.str()
	old_password := req.as_map()['oldPassword'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema.SysUser](db)
	pwd := sys_user.select('password')!.where('id = ?', user_id)!.query()!

	if pwd[0].password != old_password {
	  return error("Incorrect old password | 旧密码不正确")
	}

	sys_user.reset()
  sys_user.set('password = ?', new_password)!
          .where('id = ?', user_id)!
          .update()!

  return map[string]Any{}
}
