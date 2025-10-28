module role_permission

import veb
import log
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/menu_list'; post]
fn (app &RolePermission) role_menu_permission(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	// 解析请求 JSON
	req := json.decode[GetRoleMenuListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400('Invalid request: ${err.msg()}'))
	}

	// 调用查询函数
	mut result := role_menu_permission_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500('Failed to get role menu list: ${err.msg()}'))
	}

	// 返回成功 JSON
	return ctx.json(api.json_success_200(result))
}

// =========================
// 核心查询函数
// =========================
fn role_menu_permission_resp(mut ctx Context, req GetRoleMenuListReq) ![]&GetRoleMenuListResp {
	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire DB connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	if req.role_id == '' {
		return error('Role ID is required')
	}

	// --- 1. 查询角色已有的菜单ID ---
	mut menu_id_arr := sql db {
		select from schema_sys.SysRoleMenu where role_id == req.role_id
	} or { return error('Failed to query role menus: ${err}') }

	owned_menu_ids := menu_id_arr.map(it.menu_id)

	// --- 2. 查询所有菜单 ---
	mut all_menus := sql db {
		select from schema_sys.SysMenu where id == req.role_id
	} or { return error('Failed to query all menus: ${err}') }

	// --- 3. 构造列表 + 标记权限 ---
	mut datalist := []&GetRoleMenuListResp{}
	for row in all_menus {
		datalist << &GetRoleMenuListResp{
			id:             row.id
			parent_id:      row.parent_id or { '0' }
			menu_level:     row.menu_level
			menu_type:      row.menu_type
			name:           row.name
			has_permission: row.id in owned_menu_ids
			children:       []&GetRoleMenuListResp{}
		}
	}

	// --- 4. 构造树形结构 ---
	return build_menu_tree(mut datalist)
}

// =========================
// 构造树形结构函数
// =========================
fn build_menu_tree(mut flat_list []&GetRoleMenuListResp) []&GetRoleMenuListResp {
	mut tree := []&GetRoleMenuListResp{}
	mut lookup := map[string]&GetRoleMenuListResp{}

	// 构建 id -> 节点映射
	for item in flat_list {
		lookup[item.id] = item
	}

	// 构造树
	for item in flat_list {
		if item.parent_id == '0' || item.parent_id == '' {
			tree << item
		} else if mut parent := lookup[item.parent_id] {
			parent.children << item
		}
	}

	return tree
}

struct GetRoleMenuListReq {
	role_id string @[json: 'role_id']
}

@[heap]
struct GetRoleMenuListResp {
	id             string @[json: 'id']
	parent_id      string @[json: 'parent_id']
	menu_level     u64    @[json: 'menu_level']
	menu_type      u64    @[json: 'menu_type']
	name           string @[json: 'name']
	has_permission bool   @[json: 'has_permission']
mut:
	children []&GetRoleMenuListResp
}
