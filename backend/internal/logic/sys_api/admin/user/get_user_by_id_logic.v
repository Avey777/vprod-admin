module user

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

@['/id'; post]
fn (app &User) user_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := user_by_id_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn user_by_id_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	user_id := req.as_map()['userId'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	result := sys_user.select('id = ?', user_id)!.query()!

	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['username'] = row.username
		data['nickname'] = row.nickname
		data['status'] = int(row.status)
		//*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {
			select from schema_sys.SysUserRole where user_id == user_id
		}!
		mut user_role_ids := []string{}
		for row_urs in user_role {
			user_role_ids << row_urs.role_id
		}
		data['roleIds'] = user_role_ids

		mut user_role_names := []string{}
		for raw_role_id in user_role_ids {
			mut role := sql db {
				select from schema_sys.SysRole where id == raw_role_id
			}!
			for raw_name in role {
				user_role_names << raw_name.name
			}
		}
		data['roleName'] = user_role_names
		//*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['avatar'] = row.avatar or { '' }
		data['desc'] = row.description or { '' }
		data['homePath'] = row.home_path
		data['mobile'] = row.mobile or { '' }
		data['email'] = row.email or { '' }
		data['departmentId'] = row.department_id or { '' }
		//*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		// mut user_info := sql db {select from schema_sys.SysUser  where id == user_id limit 1}!
		mut user_info := sys_user.select('department_id')!.where('id = ?', user_id)!.query()!
		mut dpt_id := user_info[0].department_id or { '' }

		mut sys_department := orm.new_query[schema_sys.SysDepartment](db)
		department_info := sys_department.select('name')!.where('id = ?', dpt_id)!.query()!

		data['departmentName'] = department_info[0].name
		//*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['creatorId'] = row.creator_id or { '' }
		data['updaterId'] = row.updater_id or { '' }
		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	return datalist[0]
}
