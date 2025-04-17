module user

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/list'; post]
fn (app &User) user_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req_data := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }

	mut result := user_list_resp(req_data) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

pub fn user_list_resp(req_data json2.Any)  !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req_data.as_map()['page'] or {1}.int()
	page_size := req_data.as_map()['pageSize'] or {10}.int()
	department_id := req_data.as_map()['departmentId'] or {0}.int()
	username := req_data.as_map()['username'] or {''}.str()
	nickname := req_data.as_map()['nickname'] or {''}.str()
	position_id := req_data.as_map()['positionId'] or {0}.int()
	mobile := req_data.as_map()['mobile'] or {''}.str()
	email := req_data.as_map()['email'] or {''}.str()

	mut db := db_mysql()
	defer { db.close() }
	mut sys_user := orm.new_query[schema.SysUser](db)
	mut sys_user_position := orm.new_query[schema.SysUserPosition](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db { select count from schema.SysUser }!
	offset_num := (page - 1) * page_size
	/*>>>*/
	mut query := sys_user.select()!
	if department_id != 0 {
    query = query.where('department_id = ?', department_id)!
  }
  if username != '' {
      query = query.where('username = ?', username)!
  }
  if nickname != '' {
      query = query.where('nickname = ?', nickname)!
  }
  if position_id != 0 {
      query = query.where('position_id = ?', position_id)!
  }
  if mobile != '' {
      query = query.where('mobile = ?', mobile)!
  }
	if email != '' {
    query = query.where('email = ?', email)!
	}
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	/*<<<*/
	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
    mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['username'] = row.username
		data['nickname'] = row.nickname
		data['mobile'] = row.mobile or {''}
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {select from schema.SysUserRole where user_id == row.id}!
		mut user_roles_ids_list := []string{} //map空数组初始化
		for row_urs in user_role { user_roles_ids_list << row_urs.role_id }
		data['roleIds'] = user_roles_ids_list
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['email'] = row.email or {''}
		data['avatar'] = row.avatar or {''}
		data['status'] = int(row.status)
		data['description'] = row.description or {''}
		data['homePath'] = row.home_path
		data['departmentId'] = row.department_id  or {''}
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		// mut user_position := sql db {select from schema.SysUserPosition where user_id == row.id}!
		mut user_position := sys_user_position.select()!.where('user_id = ?',row.id)!.limit(1)!.query()!
		mut user_position_ids_list := []string{} //map空数组初始化
		for row_ups in user_position { user_position_ids_list << row_ups.position_id }
		data['positionId'] = user_position_ids_list
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or {time.Time{}}.format_ss()

		datalist << data //追加data到maplist 数组
 	}

  mut result_data := map[string]Any{}
  result_data['total'] = count
  result_data['data'] = datalist

	return result_data
}
