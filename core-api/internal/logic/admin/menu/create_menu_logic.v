module menu

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Create menu | 创建Menu
@['/create_menu'; post]
fn (app &Menu) create_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_menu_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_menu_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	menu := schema.SysMenu{
		id:                    rand.uuid_v7()
		parent_id:             req.as_map()['parentId'] or { '' }.str()
		menu_level:            req.as_map()['menuLevel'] or { 0 }.u64()
		menu_type:             req.as_map()['MenuType'] or { 0 }.u64()
		path:                  req.as_map()['Path'] or { '' }.str()
		name:                  req.as_map()['Name'] or { '' }.str()
		redirect:              req.as_map()['Redirect'] or { '' }.str()
		component:             req.as_map()['Component'] or { '' }.str()
		disabled:              req.as_map()['Disabled'] or { 0 }.u8()
		service_name:          req.as_map()['serviceName'] or { '' }.str()
		permission:            req.as_map()['Permission'] or { '' }.str()
		title:                 req.as_map()['Title'] or { '' }.str()
		icon:                  req.as_map()['Icon'] or { '' }.str()
		hide_menu:             req.as_map()['hideMenu'] or { 0 }.u8()
		hide_breadcrumb:       req.as_map()['hideBreadcrumb'] or { 0 }.u8()
		ignore_keep_alive:     req.as_map()['ignoreKeepAlive'] or { 0 }.u8()
		hide_tab:              req.as_map()['hide_tab'] or { 0 }.u8()
		frame_src:             req.as_map()['frameSrc'] or { '' }.str()
		carry_param:           req.as_map()['carryParam'] or { 0 }.u8()
		hide_children_in_menu: req.as_map()['hide_children_in_menu'] or { 0 }.u8()
		affix:                 req.as_map()['Affix'] or { 20 }.u8()
		dynamic_level:         req.as_map()['dynamicLevel'] or { 0 }.u8()
		real_path:             req.as_map()['real_path'] or { '' }.str()
		sort:                  req.as_map()['Sort'] or { 0 }.u64()
		created_at:            req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:            req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_menu := orm.new_query[schema.SysMenu](db)
	sys_menu.insert(menu)!

	return map[string]Any{}
}
