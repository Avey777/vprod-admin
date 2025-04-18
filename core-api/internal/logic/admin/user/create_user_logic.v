module user

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Change Password | 修改密码
@['/create_user'; post]
fn (app &User) create_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req_data := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

	mut result := create_user_resp(req_data) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

fn create_user_resp(req_data json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	users := schema.SysUser{
   	id: req_data.as_map()['id'] or { '' }.str()
   	avatar: req_data.as_map()['avatar'] or { '' }.str()
    department_id: req_data.as_map()['departmentId'] or { '' }.str()
    description: req_data.as_map()['description'] or { '' }.str()
    email: req_data.as_map()['email'] or { '' }.str()
    home_path: req_data.as_map()['homePath'] or { '' }.str()
    mobile: req_data.as_map()['mobile'] or { '' }.str()
    nickname: req_data.as_map()['nickname'] or { '' }.str()
    password: req_data.as_map()['password'] or { '' }.str()
    // position_id: req_data.as_map()['positionId'] or { []json2.Any{} }.arr()
    // role_ids: req_data.as_map()['roleIds'] or { []json2.Any{} }.arr()
    status: req_data.as_map()['status'] or { 0 }.u8()
    username: req_data.as_map()['username'] or { '' }.str()
    created_at: req_data.as_map()['createdAt'] or {time.Time{}}.to_time()!
    updated_at: req_data.as_map()['updatedAt'] or {time.Time{}}.to_time()!
	}
	dump(users)
	// mut db := db_mysql()
	// defer { db.close() }

	// mut sys_user := orm.new_query[schema.SysUser](db)
	// pwd := sys_user.select('password')!.where('id = ?', user_id)!.query()!

  return map[string]Any{}
}
