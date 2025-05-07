
			// Id:          req.Id,
			// Path:        req.Path,
			// Description: req.Description,
			// ApiGroup:    req.Group,
			// Method:      req.Method,
			// IsRequired:  req.IsRequired,
			// ServiceName: req.ServiceName,
			module api

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update api ||更新api
@['/update_api'; post]
fn (app &Api) update_token(mut ctx Context) veb.Result {
				log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

				req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
				mut result := update_api_resp(req) or { return ctx.json(json_error(503, '${err}')) }

				return ctx.json(json_success('success', result))
}

fn update_api_resp(req json2.Any) !map[string]Any {
				log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

				id := req.as_map()['Id'] or { '' }.str()
				path := req.as_map()['Path'] or { '' }.str()
				description := req.as_map()['Description'] or { '' }.str()
				api_group := req.as_map()['Group'] or { '' }.str()
				service_name := req.as_map()['ServiceName'] or { '' }.str()
				method := req.as_map()['Method'] or { '' }.str()
				is_required := req.as_map()['IsRequired'] or { 0 }.u8()

				updated_at := req.as_map()['updatedAt'] or { time.now() }.to_time()!

				mut db := db_mysql()
				defer { db.close() }

				mut sys_api := orm.new_query[schema.SysApi](db)

				sys_api.set('path = ?', path)!
					.set('description = ?', description)!
					.set('api_group = ?', api_group)!
					.set('service_name = ?', service_name)!
					.set('method = ?', method)!
					.set('is_required = ?', is_required)!
					.set('updated_at = ?', updated_at)!
					.where('id = ?', id)!
					.update()!

				return map[string]Any{}
}