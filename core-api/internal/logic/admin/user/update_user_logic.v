module user

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/update_user'; post]
fn (app &User) update_user_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

	mut result := user_by_id_resp(req) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

pub fn update_user_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()
	avatar := req.as_map()['avatar'] or { '' }.str()
  department_id := req.as_map()['departmentId'] or { '' }.str()
  description := req.as_map()['description'] or { '' }.str()
  email := req.as_map()['email'] or { '' }.str()
  home_path := req.as_map()['homePath'] or { '' }.str()
  mobile := req.as_map()['mobile'] or { '' }.str()
  nickname := req.as_map()['nickname'] or { '' }.str()
  password := req.as_map()['password'] or { '' }.str()
  status := req.as_map()['status'] or { 0 }.u8()
  username := req.as_map()['username'] or { '' }.str()
  created_at := req.as_map()['createdAt'] or {time.now()}.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
  updated_at := req.as_map()['updatedAt'] or {time.now()}.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema.SysUser](db)
	sys_user.set('id = ?', user_id)!
       	.set('avatar = ?', avatar)!
       	.set('email = ?', email)!
       	.set('mobile = ?', mobile)!
       	.set('nickname = ?', nickname)!
        .set('department_id = ?', department_id)!
        .set('description = ?', description)!
        .set('home_path = ?', home_path)!
        .set('mobile = ?', mobile)!
        .set('nickname = ?', nickname)!
        .set('password = ?', password)!
        .set('status = ?', status)!
        .set('username = ?', username)!
        .set('created_at = ?', created_at)!
        .set('updated_at = ?', updated_at)!
        .update()!

	return  map[string]Any{}
}




// 			RoleIds:      req.RoleIds,
// 			PositionIds:  req.PositionIds,
