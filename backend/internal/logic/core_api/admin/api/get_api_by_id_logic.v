module api

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema_sys
import common.api { json_success, json_error }
import internal.structs { Context }

@['/id'; post]
fn (app &Api) api_by_id(mut ctx Context) veb.Result {
				log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
				// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

				req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
				mut result := api_by_id_resp(req) or { return ctx.json(json_error(503, '${err}')) }

				return ctx.json(json_success('success', result))
}

fn api_by_id_resp(req json2.Any) !map[string]Any {
				log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

				api_id := req.as_map()['id'] or { '' }.str()

				mut db := db_mysql()
				defer { db.close() }

				mut sys_api := orm.new_query[schema_sys.SysApi](db)
				mut query := sys_api.select()!
				if api_id != '' {
					query = query.where('id = ?', api_id)!
				}
				result := query.query()!

				mut datalist := []map[string]Any{} // map空数组初始化
				for row in result {
					mut data := map[string]Any{} // map初始化
					data['id'] = row.id //主键ID
					data['Path'] = row.path
					data['Description'] = row.description or { '' }
					data['Group'] = row.api_group
					data['Method'] = row.method
					data['IsRequired'] = int(row.is_required)
					data['ServiceName'] = row.service_name

					data['createdAt'] = row.created_at.format_ss()
					data['updatedAt'] = row.updated_at.format_ss()
					data['deletedAt'] = row.deleted_at or { time.Time{} }.format_ss()

					datalist << data //追加data到maplist 数组
				}

				return datalist[0]
}
