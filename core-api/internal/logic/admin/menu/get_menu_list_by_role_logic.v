module menu

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

//根据role获取menu
@['/role/list'; post]
fn (app &Menu) role_menu_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := role_menu_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn role_menu_list_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or { 1 }.int()
	page_size := req.as_map()['pageSize'] or { 10 }.int()
	role_id := req.as_map()['roleId'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() }
	mut sys_role_menu := orm.new_query[schema.SysRoleMenu](db)
	mut sys_menu := orm.new_query[schema.SysMenu](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema.SysUser
	}!
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query_menus := sys_role_menu.select('menu_id')!
	if role_id != '' {
		query_menus = query_menus.where('role_id = ?', role_id)!
	}
	menu_id_arr := query_menus.limit(page_size)!.offset(offset_num)!.query()!

	mut query := sys_menu.select()! // .where('role_id IN ?', menu_id_arr.join(', '))!
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['parentId'] = row.parent_id or { '' }
		data['menuLevel'] = row.menu_level.str()
		data['MenuType'] = row.menu_type.str()
		data['Path'] = row.path or { '' }
		data['Name'] = row.name.str()
		data['Redirect'] = row.redirect or { '' }
		data['Component'] = row.component or { '' }
		data['Disabled'] = int(row.disabled or { 0 })
		data['serviceName'] = row.service_name or { '' }
		data['Permission'] = row.permission or { '' }
		data['Title'] = row.title.str()
		data['Icon'] = row.icon.str()
		data['hideMenu'] = int(row.hide_menu or { 0 })
		data['hideBreadcrumb'] = int(row.hide_breadcrumb or { 0 })
		data['ignoreKeepAlive'] = int(row.ignore_keep_alive or { 0 })
		data['hideTab'] = int(row.hide_tab or { 0 })
		data['frameSrc'] = row.frame_src or { '' }.str()
		data['carryParam'] = int(row.carry_param or { 0 })
		data['hideChildrenInMenu'] = int(row.hide_children_in_menu or { 0 })
		data['affix'] = int(row.affix or { 0 })
		data['dynamicLevel'] = int(row.dynamic_level or { 20 })
		data['realPath'] = row.real_path or { '' }.str()
		data['Sort'] = u64(row.sort)
		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	mut result_data := map[string]Any{}
	result_data['total'] = count
	result_data['data'] = datalist

	return result_data
}
