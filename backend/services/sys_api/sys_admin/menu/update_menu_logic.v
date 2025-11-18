module menu

import veb
import log
import orm
import time
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

// Update menu ||更新menu
@['/update_menu'; post]
fn (app &Menu) update_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[json.Any](ctx.req.data) or { return ctx.json(api.json_error_400(err.msg())) }
	mut result := update_menu_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_menu_resp(mut ctx Context, req json.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	id := req.as_map()['id'] or { '' }.str()
	parent_id := req.as_map()['parent_id'] or { '' }.str()
	menu_level := req.as_map()['menu_level'] or { 0 }.u64()
	menu_type := req.as_map()['menu_type'] or { 0 }.u64()
	path := req.as_map()['path'] or { '' }.str()
	name := req.as_map()['name'] or { '' }.str()
	redirect := req.as_map()['redirect'] or { '' }.str()
	component := req.as_map()['component'] or { '' }.str()
	disabled := req.as_map()['disabled'] or { 0 }.u8()
	service_name := req.as_map()['service_name'] or { '' }.str()
	permission := req.as_map()['permission'] or { '' }.str()
	title := req.as_map()['title'] or { '' }.str()
	icon := req.as_map()['icon'] or { '' }.str()
	hide_menu := req.as_map()['hide_menu'] or { 0 }.u8()
	hide_breadcrumb := req.as_map()['hide_breadcrumb'] or { 0 }.u8()
	ignore_keep_alive := req.as_map()['ignore_keep_alive'] or { 0 }.u8()
	hide_tab := req.as_map()['hide_tab'] or { 0 }.u8()
	frame_src := req.as_map()['frame_src'] or { '' }.str()
	carry_param := req.as_map()['carry_param'] or { 0 }.u8()
	hide_children_in_menu := req.as_map()['hide_children_in_menu'] or { 0 }.u8()
	affix := req.as_map()['affix'] or { 20 }.u8()
	dynamic_level := req.as_map()['dynamic_level'] or { 0 }.u64()
	real_path := req.as_map()['real_path'] or { '' }.str()
	sort := req.as_map()['sort'] or { 0 }.u64()
	updated_at := req.as_map()['updated_at'] or { time.now() }.to_time()!

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut sys_menu := orm.new_query[schema_sys.SysMenu](db)

	sys_menu.set('parent_id = ?', parent_id)!
		.set('menu_level = ?', menu_level)!
		.set('menu_type = ?', menu_type)!
		.set('path = ?', path)!
		.set('name = ?', name)!
		.set('redirect = ?', redirect)!
		.set('component = ?', component)!
		.set('disabled = ?', disabled)!
		.set('service_name = ?', service_name)!
		.set('permission = ?', permission)!
		.set('title = ?', title)!
		.set('icon = ?', icon)!
		.set('hide_menu = ?', hide_menu)!
		.set('hide_breadcrumb = ?', hide_breadcrumb)!
		.set('ignore_keep_alive = ?', ignore_keep_alive)!
		.set('hide_tab = ?', hide_tab)!
		.set('frame_src = ?', frame_src)!
		.set('carry_param = ?', carry_param)!
		.set('hide_children_in_menu = ?', hide_children_in_menu)!
		.set('affix = ?', affix)!
		.set('dynamic_level = ?', dynamic_level)!
		.set('real_path = ?', real_path)!
		.set('sort = ?', sort)!
		.set('updated_at = ?', updated_at)!
		.where('id = ?', id)!
		.update()!

	return map[string]Any{}
}
