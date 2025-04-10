module user

import veb
import log
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

	user_id := req_data.as_map()['userId'] or { 1 }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut result := sql db {
		select from schema.SysUser
	} or {
		log.debug('result 查询失败')
		return err
	}
	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
		mut data := map[string]Any{} // map初始化
		data['userId'] = row.id //主键ID
		data['username'] = row.username
		data['nickname'] = row.nickname
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {
		  select from schema.SysRole where id == user_id
		} or {return err}
		mut user_roles_ids_list := []string{} //map空数组初始化
		for row_urs in user_role { user_roles_ids_list << row_urs.name }
		data['roleName'] = user_roles_ids_list
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['avatar'] = row.avatar or {''}
		data['desc'] = row.description or {''}
		data['homePath'] = row.home_path
		data['departmentName'] = row.department_id  or {''}

		datalist << data //追加data到maplist 数组
 	}

	return map[string]Any{}
}
