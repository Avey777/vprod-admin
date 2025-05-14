
		// 	Page:        req.Page,
		// 	PageSize:    req.PageSize,
		// 	Path:        req.Path,
		// 	Description: req.Description,
		// 	Method:      req.Method,
		// 	ApiGroup:    req.Group,
		// 	ServiceName: req.ServiceName,

		// resp.Data.Data = append(resp.Data.Data,
		// 	types.ApiInfo{
		// 		BaseIDInfo: types.BaseIDInfo{
		// 			Id:        v.Id,
		// 			CreatedAt: v.CreatedAt,
		// 			UpdatedAt: v.UpdatedAt,
		// 		},
		// 		Path:        v.Path,
		// 		Trans:       l.svcCtx.Trans.Trans(l.ctx, *v.Description),
		// 		Description: v.Description,
		// 		Group:       v.ApiGroup,
		// 		Method:      v.Method,
		// 		IsRequired:  v.IsRequired,
		// 		ServiceName: v.ServiceName,
		module api

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import common.api { json_success, json_error }
import internal.structs { Context }

@['/list'; post]
fn (app &Api) api_list(mut ctx Context) veb.Result {
			log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
			// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

			req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
			mut result := api_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

			return ctx.json(json_success('success', result))
}

fn api_list_resp(req json2.Any) !map[string]Any {
			log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

			page := req.as_map()['page'] or { 1 }.int()
			page_size := req.as_map()['pageSize'] or { 10 }.int()
			path := req.as_map()['Path'] or { '' }.str()
			description := req.as_map()['Description'] or { '' }.str()
			api_group := req.as_map()['Group'] or { '' }.str()
			service_name := req.as_map()['ServiceName'] or { '' }.str()
			method := req.as_map()['Method'] or { '' }.str()
			is_required := req.as_map()['IsRequired'] or { 0 }.u8()

			mut db := db_mysql()
			defer { db.close() }
			mut sys_api := orm.new_query[schema.SysApi](db)
			// 总页数查询 - 分页偏移量构造
			mut count := sql db {
				select count from schema.SysUser
			}!
			offset_num := (page - 1) * page_size
			//*>>>*/
			mut query := sys_api.select()!
			if name != '' {
				query = query.where('name = ?', name)!
			}
			if key != '' {
				query = query.where('leader = ?', key)!
			}
			if category in [0, 1] {
				query = query.where('status = ?', category)!
			}
			result := query.limit(page_size)!.offset(offset_num)!.query()!
			//*<<<*/
			mut datalist := []map[string]Any{} // map空数组初始化
			for row in result {
				mut data := map[string]Any{} // map初始化
				data['id'] = row.id //主键ID
				data['Path'] = int(row.path)
				data['Description'] = row.description or { '' }
				data['Group'] = row.api_group
				data['Method'] = row.method
				data['IsRequired'] = row.category
				data['ServiceName'] = row.is_required

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
