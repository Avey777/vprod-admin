// 根据租户ID和应用订阅ID,获取租户角色的api权限

module role_permission

import veb
import log
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/tenant_role_permission/apt_list'; post]
fn (app &RolePermission) role_api_permission(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 解析请求 JSON
	req := json.decode[GetRoleApiListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400('Invalid request: ${err.msg()}'))
	}

	// 调用查询函数
	mut result := role_api_permission_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500('Failed to get role api list: ${err.msg()}'))
	}

	// 返回成功 JSON
	return ctx.json(api.json_success_200(result))
}

fn role_api_permission_resp(mut ctx Context, req GetRoleApiListReq) !map[string][]GetRoleApiListResp {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	if req.role_id == '' || req.source_id == '' || req.source_type == '' {
		return error('Role ID is required')
	}

	// --- 1. 查询角色已有的 API ---
	mut api_id_arr := sql db {
		select from schema_core.CoreRoleApi where role_id == req.role_id
		&& source_type == req.source_type && source_id == req.source_id
	} or { return error('Failed to query role APIs: ${err}') }

	owned_api_ids := api_id_arr.map(it.api_id)

	// --- 2. 查询所有 API ---
	mut all_apis_db := sql db {
		select from schema_core.CoreApi where source_type == req.source_type
		&& source_id == req.source_id
	} or { return error('Failed to query all APIs: ${err}') }

	// --- 3. 构造 API 列表 ---
	mut all_apis := []GetRoleApiListResp{}
	for row in all_apis_db {
		all_apis << GetRoleApiListResp{
			id:             row.id
			path:           row.path
			description:    row.description
			api_group:      row.api_group
			service_name:   row.service_name
			method:         row.method
			is_required:    row.is_required
			source_type:    row.source_type
			source_id:      row.source_id
			has_permission: row.is_required == 1 || row.id in owned_api_ids
		}
	}

	// --- 4. 按 api_group 分组 ---
	mut grouped := map[string][]GetRoleApiListResp{}
	for api in all_apis {
		group := if api.api_group.trim_space() == '' { 'Other' } else { api.api_group }
		grouped[group] << api
	}

	return grouped
}

struct GetRoleApiListReq {
	source_type string @[json: 'source_type']
	source_id   string @[json: 'source_id']
	tenant_id   string @[json: 'tenant_id']
	role_id     string @[json: 'role_id']
}

struct GetRoleApiListResp {
	id             string  @[json: 'id']
	path           string  @[json: 'path']
	description    ?string @[json: 'description']
	api_group      string  @[json: 'api_group']
	service_name   string  @[json: 'service_name']
	method         string  @[json: 'method']
	is_required    u8      @[json: 'is_required']
	source_type    string  @[json: 'source_type']
	source_id      string  @[json: 'source_id']
	has_permission bool    @[json: 'has_permission']
}
