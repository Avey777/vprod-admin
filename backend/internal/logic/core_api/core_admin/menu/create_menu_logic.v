module menu

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_core
import common.api
import internal.structs { Context }

// Create menu | 创建Menu
@['/create_menu'; post]
fn (app &Menu) create_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateMenuReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_menu_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_menu_resp(mut ctx Context, req CreateMenuReq) !CreateCoreMenuResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	menu := schema_core.CoreMenu{
		id:                    rand.uuid_v7()
		parent_id:             req.parent_id
		menu_level:            req.menu_level
		menu_type:             req.menu_type
		path:                  req.path
		name:                  req.name
		redirect:              req.redirect
		component:             req.component
		disabled:              req.disabled
		service_name:          req.service_name
		permission:            req.permission
		title:                 req.title
		icon:                  req.icon
		hide_menu:             req.hide_menu
		hide_breadcrumb:       req.hide_breadcrumb
		ignore_keep_alive:     req.ignore_keep_alive
		hide_tab:              req.hide_tab
		frame_src:             req.frame_src
		carry_param:           req.carry_param
		hide_children_in_menu: req.hide_children_in_menu
		affix:                 req.affix
		dynamic_level:         req.dynamic_level
		real_path:             req.real_path
		sort:                  req.sort
		source_type:           req.source_type
		source_id:             req.source_id
		created_at:            req.created_at
		updated_at:            req.updated_at
	}
	mut core_menu := orm.new_query[schema_core.CoreMenu](db)
	core_menu.insert(menu)!

	return CreateCoreMenuResp{
		msg: 'CoreMenu created successfully'
	}
}

struct CreateMenuReq {
	id                    string    @[json: 'id']
	parent_id             string    @[json: 'parent_id']
	menu_level            u64       @[default: 0; json: 'menuLevel']
	menu_type             u64       @[default: 0; json: 'menuType']
	path                  string    @[json: 'path']
	name                  string    @[json: 'name']
	redirect              string    @[json: 'redirect']
	component             string    @[json: 'component']
	disabled              u8        @[default: 0; json: 'disabled']
	service_name          string    @[json: 'service_name']
	permission            string    @[json: 'permission']
	title                 string    @[json: 'title']
	icon                  string    @[json: 'icon']
	hide_menu             u8        @[default: 0; json: 'hideMenu']
	hide_breadcrumb       u8        @[default: 0; json: 'hideBreadcrumb']
	ignore_keep_alive     u8        @[default: 0; json: 'ignoreKeepAlive']
	hide_tab              u8        @[default: 0; json: 'hideTab']
	frame_src             string    @[json: 'frame_src']
	carry_param           u8        @[default: 0; json: 'carryParam']
	hide_children_in_menu u8        @[default: 0; json: 'hideChildrenInMenu']
	affix                 u8        @[default: 20; json: 'affix']
	dynamic_level         u8        @[default: 0; json: 'dynamicLevel']
	real_path             string    @[json: 'real_path']
	sort                  u32       @[default: 0; json: 'sort']
	source_type           string    @[json: 'source_type']
	source_id             string    @[json: 'source_id']
	created_at            time.Time @[json: 'created_at']
	updated_at            time.Time @[json: 'updated_at']
}

struct CreateCoreMenuResp {
	msg string
}
