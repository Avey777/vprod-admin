module menu

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_error, json_success }
import internal.structs { Context }

// Create menu | 创建Menu
@['/create_menu'; post]
fn (app &Menu) create_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_menu_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success(200,'success', result))
}

fn create_menu_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() or {panic} }

	menu := schema_sys.SysMenu{
		id:                    rand.uuid_v7()
		parent_id:             req.as_map()['parent_id'] or { '' }.str()
		menu_level:            req.as_map()['menu_level'] or { 0 }.u64()
		menu_type:             req.as_map()['menu_type'] or { 0 }.u64()
		path:                  req.as_map()['path'] or { '' }.str()
		name:                  req.as_map()['name'] or { '' }.str()
		redirect:              req.as_map()['redirect'] or { '' }.str()
		component:             req.as_map()['component'] or { '' }.str()
		disabled:              req.as_map()['disabled'] or { 0 }.u8()
		service_name:          req.as_map()['service_name'] or { '' }.str()
		permission:            req.as_map()['permission'] or { '' }.str()
		title:                 req.as_map()['title'] or { '' }.str()
		icon:                  req.as_map()['icon'] or { '' }.str()
		hide_menu:             req.as_map()['hide_menu'] or { 0 }.u8()
		hide_breadcrumb:       req.as_map()['hide_breadcrumb'] or { 0 }.u8()
		ignore_keep_alive:     req.as_map()['ignore_keep_alive'] or { 0 }.u8()
		hide_tab:              req.as_map()['hide_tab'] or { 0 }.u8()
		frame_src:             req.as_map()['frame_src'] or { '' }.str()
		carry_param:           req.as_map()['carry_param'] or { 0 }.u8()
		hide_children_in_menu: req.as_map()['hide_children_in_menu'] or { 0 }.u8()
		affix:                 req.as_map()['affix'] or { 20 }.u8()
		dynamic_level:         req.as_map()['dynamic_level'] or { 0 }.u8()
		real_path:             req.as_map()['real_path'] or { '' }.str()
		sort:                  req.as_map()['sort'] or { 0 }.u32()
		created_at:            req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:            req.as_map()['updated_at'] or { time.now() }.to_time()!
	}
	mut sys_menu := orm.new_query[schema_sys.SysMenu](db)
	sys_menu.insert(menu)!

	return map[string]Any{}
}
