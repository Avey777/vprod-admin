module menu

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update menu ||更新menu
@['/update_menu'; post]
fn (app &Menu) update_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := update_menu_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn update_menu_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['Id'] or { '' }.str()
	parent_id := req.as_map()['parentId'] or { '' }.str()
	menu_level := req.as_map()['menuLevel'] or { 0 }.u64()
	menu_type := req.as_map()['MenuType'] or { 0 }.u64()
	path := req.as_map()['Path'] or { '' }.str()
	name := req.as_map()['Name'] or { '' }.str()
	redirect := req.as_map()['Redirect'] or { '' }.str()
	component := req.as_map()['Component'] or { '' }.str()
	disabled := req.as_map()['Disabled'] or { 0 }.u8()
	service_name := req.as_map()['serviceName'] or { '' }.str()
	permission := req.as_map()['Permission'] or { '' }.str()
	title := req.as_map()['Title'] or { '' }.str()
	icon := req.as_map()['Icon'] or { '' }.str()
	hide_menu := req.as_map()['hideMenu'] or { 0 }.u8()
	hide_breadcrumb := req.as_map()['hideBreadcrumb'] or { 0 }.u8()
	ignore_keep_alive := req.as_map()['ignoreKeepAlive'] or { 0 }.u8()
	hide_tab := req.as_map()['hide_tab'] or { 0 }.u8()
	frame_src := req.as_map()['frameSrc'] or { '' }.str()
	carry_param := req.as_map()['carryParam'] or { 0 }.u8()
	hide_children_in_menu := req.as_map()['hide_children_in_menu'] or { 0 }.u8()
	affix := req.as_map()['Affix'] or { 20 }.u8()
	dynamic_level := req.as_map()['dynamicLevel'] or { 0 }.u64()
	real_path := req.as_map()['real_path'] or { '' }.str()
	sort := req.as_map()['Sort'] or { 0 }.u64()
	updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

	mut db := db_mysql()
	defer { db.close() }

	mut sys_menu := orm.new_query[schema.SysMenu](db)

	sys_menu.set('parent_id = ?', parent_id)!
		.set('menu_level = ?', menu_level)!
		.set('menu_type = ?', menu_type)!
		// .set('path = ?', path)!
		// .set('name = ?', name)!
		// .set('redirect = ?', redirect)!
		// .set('component = ?', component)!
		// .set('disabled = ?', disabled)!
		// .set('service_name = ?', service_name)!
		// .set('permission = ?', permission)!
		// .set('title = ?', title)!
		// .set('icon = ?', icon)!
		// .set('hide_menu = ?', hide_menu)!
		// .set('hide_breadcrumb = ?', hide_breadcrumb)!
		// .set('ignore_keep_alive = ?', ignore_keep_alive)!
		// .set('hide_tab = ?', hide_tab)!
		// .set('frame_src = ?', frame_src)!
		// .set('carry_param = ?', carry_param)!
		// .set('hide_children_in_menu = ?', hide_children_in_menu)!
		// .set('affix = ?', affix)!
		// .set('dynamic_level = ?', dynamic_level)!
		// .set('real_path = ?', real_path)!
		// .set('sort = ?', sort)!
		// .set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
