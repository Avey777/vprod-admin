module menu

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

//根据role获取menu
@['/role/list'; get]
fn (app &Menu) role_menu_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	dump('4646466')
	mut result := role_menu_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success(200,'success', result))
}

fn role_menu_list_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or { 1 }.int()
	page_size := req.as_map()['page_size'] or { 10000 }.int()
	role_id := req.as_map()['role_id'] or { '' }.str()

	mut db := db_mysql()
	defer { db.close() or {panic} }
	mut sys_role_menu := orm.new_query[schema_sys.SysRoleMenu](db)
	mut sys_menu := orm.new_query[schema_sys.SysMenu](db)
	// 分页偏移量构造
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query_menus := sys_role_menu.select('menu_id')!
	if role_id != '' {
		query_menus = query_menus.where('role_id = ?', role_id)!
	}
	menu_id_arr := query_menus.limit(page_size)!.offset(offset_num)!.query()!

	// 2. 提取所需的 ID 值到基础类型切片
	mut menu_ids := []orm.Primitive{}
	for item in menu_id_arr {
		menu_ids << item.menu_id
	}
	// 3. 检查空数组避免 SQL 错误
	if menu_ids.len == 0 {
		return map[string]Any{}
	}

	mut query := sys_menu.select()!.where('id IN ?', menu_ids)!
	mut count := query.count()! // 数据总数量
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} // map空数组初始化
	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['parent_id'] = row.parent_id or { '' }
		data['menu_level'] = row.menu_level.str()
		data['menu_type'] = row.menu_type.str()
		data['path'] = row.path or { '' }
		data['name'] = row.name.str()
		data['redirect'] = row.redirect or { '' }
		data['component'] = row.component or { '' }
		data['disabled'] = int(row.disabled or { 0 })
		data['service_name'] = row.service_name or { '' }
		data['permission'] = row.permission or { '' }
		data['title'] = row.title.str()
		data['icon'] = row.icon.str()
		data['hide_menu'] = int(row.hide_menu or { 0 })
		data['hide_breadcrumb'] = int(row.hide_breadcrumb or { 0 })
		data['ignore_keep_alive'] = int(row.ignore_keep_alive or { 0 })
		data['hide_tab'] = int(row.hide_tab or { 0 })
		data['frame_src'] = row.frame_src or { '' }.str()
		data['carry_param'] = int(row.carry_param or { 0 })
		data['hide_children_in_menu'] = int(row.hide_children_in_menu or { 0 })
		data['affix'] = int(row.affix or { 0 })
		data['dynamic_level'] = int(row.dynamic_level or { 20 })
		data['real_path'] = row.real_path or { '' }.str()
		data['sort'] = int(row.sort)
		data['created_at'] = row.created_at.format_ss()
		data['updated_at'] = row.updated_at.format_ss()
		data['deleted_at'] = row.deleted_at or { time.Time{} }.format_ss()

		datalist << data //追加data到maplist 数组
	}

	mut result_data := map[string]Any{}
	result_data['total'] = count
	result_data['data'] = datalist

	return result_data
}
