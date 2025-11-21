module menu

import veb
import log
import time
import orm
import x.json2 as json
import structs.schema_core { CoreMenu, CoreRoleMenu }
import common.api
import structs { Context }

// ----------------- Handler 层 -----------------
@['/role/list'; get]
pub fn role_menu_list_handler(app &Menu, mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[GetMenuListByRoleReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	result := get_menu_list_by_role_usecase(mut ctx, req) or {
		return ctx.json(api.json_error_500('Internal Server Error: ${err}'))
	}

	return ctx.json(api.json_success_200(result))
}

// ----------------- Application Service | Usecase 层 -----------------
pub fn get_menu_list_by_role_usecase(mut ctx Context, req GetMenuListByRoleReq) !GetMenuListByRoleResp {
	// Domain 参数校验
	get_menu_list_by_role_domain(req)!

	// Repository 查询
	return get_menu_list_by_role_repo(mut ctx, req)
}

// ----------------- Domain 层 -----------------
fn get_menu_list_by_role_domain(req GetMenuListByRoleReq) ! {
	if req.page <= 0 || req.page_size <= 0 {
		return error('page and page_size must be positive integers')
	}
	if req.role_id == '' {
		return error('role_id is required')
	}
}

// ----------------- DTO 层 -----------------
pub struct GetMenuListByRoleReq {
	page      int    @[default: 1; json: 'page']
	page_size int    @[default: 10; json: 'page_size']
	role_id   string @[json: 'role_id']
}

pub struct GetMenuListByRole {
	id                    string     @[json: 'id']
	parent_id             string     @[json: 'parent_id']
	menu_level            u64        @[json: 'menu_level']
	menu_type             u64        @[json: 'menu_type']
	path                  string     @[json: 'path']
	name                  string     @[json: 'name']
	redirect              string     @[json: 'redirect']
	component             string     @[json: 'component']
	disabled              u8         @[json: 'disabled']
	service_name          string     @[json: 'service_name']
	permission            string     @[json: 'permission']
	title                 string     @[json: 'title']
	icon                  string     @[json: 'icon']
	hide_menu             u8         @[json: 'hide_menu']
	hide_breadcrumb       u8         @[json: 'hide_breadcrumb']
	ignore_keep_alive     u8         @[json: 'ignore_keep_alive']
	hide_tab              u8         @[json: 'hide_tab']
	frame_src             string     @[json: 'frame_src']
	carry_param           u8         @[json: 'carry_param']
	hide_children_in_menu u8         @[json: 'hide_children_in_menu']
	affix                 u8         @[json: 'affix']
	dynamic_level         u32        @[default: 20; json: 'dynamic_level']
	real_path             string     @[json: 'real_path']
	sort                  u32        @[json: 'sort']
	source_type           string     @[json: 'source_type']
	source_id             string     @[json: 'source_id']
	created_at            ?time.Time @[json: 'created_at']
	updated_at            ?time.Time @[json: 'updated_at']
	deleted_at            ?time.Time @[json: 'deleted_at']
}

pub struct GetMenuListByRoleResp {
	total int
	data  []GetMenuListByRole
}

// ----------------- Repository 层 -----------------
fn get_menu_list_by_role_repo(mut ctx Context, req GetMenuListByRoleReq) !GetMenuListByRoleResp {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { log.warn('Failed to release connection: ${err}') }
	}

	mut q_role_menu := orm.new_query[CoreRoleMenu](db)
	mut q_menu := orm.new_query[CoreMenu](db)

	offset_num := (req.page - 1) * req.page_size

	// 获取菜单ID
	mut query_menus := q_role_menu.select('menu_id')!.where('role_id = ?', req.role_id)!
	menu_id_arr := query_menus.limit(req.page_size)!.offset(offset_num)!.query()!

	if menu_id_arr.len == 0 {
		return GetMenuListByRoleResp{
			total: 0
			data:  []GetMenuListByRole{}
		}
	}

	mut menu_ids := []orm.Primitive{}
	for item in menu_id_arr {
		menu_ids << item.menu_id
	}

	// 查询菜单详情
	mut query := q_menu.select()!.where('id IN ?', menu_ids)!
	total := query.count()!
	result := query.limit(req.page_size)!.offset(offset_num)!.query()!

	mut datalist := []GetMenuListByRole{}
	for row in result {
		datalist << GetMenuListByRole{
			id:                    row.id
			parent_id:             row.parent_id or { '' }
			menu_level:            row.menu_level
			menu_type:             row.menu_type
			path:                  row.path or { '' }
			name:                  row.name
			redirect:              row.redirect or { '' }
			component:             row.component or { '' }
			disabled:              row.disabled or { 0 }
			service_name:          row.service_name
			permission:            row.permission or { '' }
			title:                 row.title
			icon:                  row.icon
			hide_menu:             row.hide_menu or { 0 }
			hide_breadcrumb:       row.hide_breadcrumb or { 0 }
			ignore_keep_alive:     row.ignore_keep_alive or { 0 }
			hide_tab:              row.hide_tab or { 0 }
			frame_src:             row.frame_src or { '' }
			carry_param:           row.carry_param or { 0 }
			hide_children_in_menu: row.hide_children_in_menu or { 0 }
			affix:                 row.affix or { 0 }
			dynamic_level:         row.dynamic_level or { 20 }
			real_path:             row.real_path or { '' }
			sort:                  row.sort
			source_type:           row.source_type
			source_id:             row.source_id
			created_at:            row.created_at
			updated_at:            row.updated_at
			deleted_at:            row.deleted_at
		}
	}

	return GetMenuListByRoleResp{
		total: total
		data:  datalist
	}
}
