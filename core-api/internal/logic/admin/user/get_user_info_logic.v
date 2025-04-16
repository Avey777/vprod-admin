module user

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/info'; get]
fn (app &User) user_info_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req_data := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

	mut result := user_info(req_data) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

pub fn user_info(req_data json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req_data.as_map()['userId'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema.SysUser](db)
	result := sys_user.select()!.query()!
	dump(result)

	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
		mut data := map[string]Any{} // map初始化
		data['userId'] = row.id //主键ID
		data['username'] = row.username
		data['nickname'] = row.nickname
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {select from schema.SysUserRole  where user_id == user_id}!
		mut user_role_ids := []string{}
		for row_urs in user_role { user_role_ids << row_urs.role_id }

		mut user_role_names := []string{}
  	for raw_role_id in user_role_ids{
      mut role := sql db {select from schema.SysRole where id == raw_role_id}!
      for raw_name in role{ user_role_names << raw_name.name }
  	}
		data['roleName'] = user_role_names
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['avatar'] = row.avatar or {''}
		data['desc'] = row.description or {''}
		data['homePath'] = row.home_path
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		// mut user_info := sql db {select from schema.SysUser  where id == user_id limit 1}!
		mut user_info := sys_user.select('department_id')!.where('id = ?', user_id)!.query()!
		mut dpt_id := user_info[0].department_id or {''}

		mut sys_department := orm.new_query[schema.SysDepartment](db)
		department_info := sys_department.select('name')!.where('id = ?',dpt_id)!.query()!

		data['departmentName'] = department_info[0].name
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/

		datalist << data //追加data到maplist 数组
 	}

	return datalist[0]
}
