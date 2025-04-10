module user

import veb
import log
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/list'; post]
fn (app &User) user_list_logic(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req_data := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	println(req_data.as_map()['username'] or {''}.str())
	page := req_data.as_map()['page'] or {1}.int()
	page_size := req_data.as_map()['page_size'] or {10}.int()

	mut result := user_list(page,page_size) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

pub fn user_list(page int ,page_size int)  !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }
	// 总页数查询
	mut count := sql db {
		select count from schema.SysUser
	} or {
		log.debug('select count from schema.SysUser 查询失败')
		return err
	}

	// 分页数据查询
	offset_num := (page - 1) * page_size
	mut result := sql db {
		select from schema.SysUser  limit page_size offset offset_num
	} or {
		log.debug('result 查询失败')
		return err
	}

	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
    mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['username'] = row.username
		data['nickname'] = row.nickname
		data['mobile'] = row.mobile or {''}
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {
		  select from schema.SysUserRole where user_id == row.id
		} or {return err}
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
		mut user_position := sql db {
		  select from schema.SysUserPosition where user_id == row.id
		} or {return err}
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
