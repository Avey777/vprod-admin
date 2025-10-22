module tenant_menu

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

//根据role获取menu
@['/role/list'; get]
fn (app &Menu) role_menu_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetMenuListByRoleReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	mut result := role_menu_list_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn role_menu_list_resp(mut ctx Context, req GetMenuListByRoleReq) !GetMenuListByRoleResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_role_menu := orm.new_query[schema_core.CoreRoleMenu](db)
	mut core_menu := orm.new_query[schema_core.CoreMenu](db)
	// 分页偏移量构造
	offset_num := (req.page - 1) * req.page_size
	//*>>>*/
	mut query_menus := core_role_menu.select('menu_id')!
	if req.role_id != '' {
		query_menus = query_menus.where('role_id = ?', req.role_id)!
	}
	menu_id_arr := query_menus.limit(req.page_size)!.offset(offset_num)!.query()!

	// 2. 提取所需的 ID 值到基础类型切片
	mut menu_ids := []orm.Primitive{}
	for item in menu_id_arr {
		menu_ids << item.menu_id
	}
	// 3. 检查空数组避免 SQL 错误
	if menu_ids.len == 0 {
		return error('No menu IDs found')
	}

	mut query := core_menu.select()!
		.where('source_type = ?', 'tenant')!
		.where('source_type = ?', req.source_type)!
		.where('source_id = ?', req.source_id)!
		.where('id IN ?', menu_ids)!
	mut count := query.count()! // 数据总数量
	result := query.limit(req.page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []GetMenuListByRole{} // map空数组初始化
	for row in result {
		mut data := GetMenuListByRole{
			id:                    row.id //主键ID
			parent_id:             row.parent_id or { return error('Parent ID not found') }
			menu_level:            row.menu_level
			menu_type:             row.menu_type
			path:                  row.path or { return error('Path not found') }
			name:                  row.name
			redirect:              row.redirect or { return error('Redirect not found') }
			component:             row.component or { return error('Component not found') }
			disabled:              row.disabled or { return error('Disabled not found') }
			service_name:          row.service_name
			permission:            row.permission or { return error('Permission not found') }
			title:                 row.title
			icon:                  row.icon
			hide_menu:             row.hide_menu or { return error('Hide menu not found') }
			hide_breadcrumb:       row.hide_breadcrumb or {
				return error('Hide breadcrumb not found')
			}
			ignore_keep_alive:     row.ignore_keep_alive or {
				return error('Ignore keep alive not found')
			}
			hide_tab:              row.hide_tab or { return error('Hide tab not found') }
			frame_src:             row.frame_src or { return error('Frame src not found') }
			carry_param:           row.carry_param or { return error('Carry param not found') }
			hide_children_in_menu: row.hide_children_in_menu or {
				return error('Hide children in menu not found')
			}
			affix:                 row.affix or { return error('Affix not found') }
			dynamic_level:         row.dynamic_level or { return error('Dynamic level not found') }
			real_path:             row.real_path or { return error('Real path not found') }
			sort:                  row.sort
			source_type:           row.source_type
			source_id:             row.source_id
			created_at:            row.created_at
			updated_at:            row.updated_at
			deleted_at:            row.deleted_at
		}

		datalist << data //追加data到maplist 数组
	}

	mut result_data := GetMenuListByRoleResp{
		total: count
		data:  datalist
	}

	return result_data
}

struct GetMenuListByRoleReq {
	page        int    @[default: 1; json: 'page']
	page_size   int    @[default: 10; json: 'page_size']
	role_id     string @[json: 'role_id']
	source_type string @[json: 'source_type']
	source_id   string @[json: 'source_id']
}

struct GetMenuListByRole {
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

struct GetMenuListByRoleResp {
	total int
	data  []GetMenuListByRole
}
