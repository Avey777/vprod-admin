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

	mut result := update_user_resp(req) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

fn update_user_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()
	position_ids :=req.as_map()['positionId'] or { []json2.Any{} }.arr()
	rule_ids := req.as_map()['roleIds'] or { []json2.Any{} }.arr()
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
  updated_at := req.as_map()['updatedAt'] or {time.now()}.to_time()!

 	mut user_positions := []schema.SysUserPosition{cap: position_ids.len}
   for raw in position_ids {
       user_positions << schema.SysUserPosition{
           user_id: user_id,
           position_id: raw.str()
       }
   }

   mut user_roles := []schema.SysUserRole{cap: rule_ids.len}
   for raw in rule_ids {
       user_roles << schema.SysUserRole{
           user_id: user_id,
           role_id: raw.str()
       }
   }

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema.SysUser](db)
	mut user_position := orm.new_query[schema.SysUserPosition](db)
  mut user_role := orm.new_query[schema.SysUserRole](db)


	sys_user.set('avatar = ?', avatar)!
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
          .set('updated_at = ?', updated_at)!
          .where('id = ?', user_id)!
          .update()!

  user_position.delete()!.where('user_id = ?', user_id)!
                .insert_many(user_positions)!

  user_role.delete()!.where('user_id = ?', user_id)!
            .insert_many(user_roles)!

	return  map[string]Any{}
}
