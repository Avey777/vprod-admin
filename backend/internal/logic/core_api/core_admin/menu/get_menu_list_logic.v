module menu

import veb
import log
import time
import orm
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/list'; post]
fn (app &Menu) menu_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json.decode[GetMenuListByListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := menu_list_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn menu_list_resp(mut ctx Context, req GetMenuListByListReq) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_menu := orm.new_query[schema_core.CoreMenu](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db {
		select count from schema_core.CoreUser
	}!
	offset_num := (req.page - 1) * req.page_size
	//*>>>*/
	mut query := core_menu.select()!
	if req.name != '' {
		query = query.where('name = ?', req.name)!
	}
	result := query.limit(req.page_size)!.offset(offset_num)!.query()!
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
		data['serviceName'] = row.service_name
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
		data['Sort'] = int(row.sort)
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

struct GetMenuListByListReq {
	page      int    @[default: 1; json: 'page']
	page_size int    @[default: 10; json: 'page_size']
	name      string @[json: 'name']
}
