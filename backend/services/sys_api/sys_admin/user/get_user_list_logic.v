module user

import veb
import log
import time
import orm
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

@['/list'; post]
fn (app &User) user_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	println('wowowowowowowoow:${ctx.config}')
	req := json.decode[GetUserListReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	// 添加参数验证
	if req.page_size <= 0 {
		return ctx.json(api.json_error_500('page_size must be a positive integer'))
	}
	if req.page <= 0 {
		return ctx.json(api.json_error_500('page must be a positive integer'))
	}

	mut result := user_list_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500('Internal Server Error:${err}'))
	}

	return ctx.json(api.json_success_200(result))
}

fn user_list_resp(mut ctx Context, req GetUserListReq) !GetUserListResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut count := sql db {
		select count from schema_sys.SysUser
	}!
	offset_num := (req.page - 1) * req.page_size

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut sys_user_position := orm.new_query[schema_sys.SysUserPosition](db)
	mut sys_user_role := orm.new_query[schema_sys.SysUserRole](db)

	mut query := sys_user.select()!
	if req.department_id != 0 {
		query = query.where('department_id = ?', req.department_id)!
	}
	if req.username != '' {
		query = query.where('username = ?', req.username)!
	}
	if req.nickname != '' {
		query = query.where('nickname = ?', req.nickname)!
	}
	if req.position_id != 0 {
		query = query.where('position_id = ?', req.position_id)!
	}
	if req.mobile != '' {
		query = query.where('mobile = ?', req.mobile)!
	}
	if req.email != '' {
		query = query.where('email = ?', req.email)!
	}

	result := query.limit(req.page_size)!.offset(offset_num)!.query()!

	mut datalist := []GetUserList{}
	for row in result {
		// Get user roles
		user_roles := sys_user_role.select()!.where('user_id = ?', row.id)!.query()!
		mut role_ids := []string{}
		for user_role in user_roles {
			role_ids << user_role.role_id
		}

		// Get user positions
		user_positions := sys_user_position.select()!.where('user_id = ?', row.id)!.query()!
		mut position_ids := []string{}
		for user_position in user_positions {
			position_ids << user_position.position_id
		}

		data := GetUserList{
			id:          row.id
			username:    row.username
			nickname:    row.nickname
			mobile:      row.mobile or { '' }
			email:       row.email or { '' }
			role_ids:    role_ids
			avatar:      row.avatar or { '' }
			status:      row.status
			description: row.description or { '' }
			home_path:   row.home_path
			position_id: position_ids
			created_at:  row.created_at
			updated_at:  row.updated_at
			deleted_at:  row.deleted_at
		}
		datalist << data
	}

	result_data := GetUserListResp{
		total: count
		data:  datalist
	}

	return result_data
}

struct GetUserListReq {
	page          int    @[json: 'page']
	page_size     int    @[json: 'page_size']
	department_id int    @[json: 'department_id']
	username      string @[json: 'username']
	nickname      string @[json: 'nickname']
	position_id   int    @[json: 'position_id']
	mobile        string @[json: 'mobile']
	email         string @[json: 'email']
}

struct GetUserListResp {
	total int
	data  []GetUserList
}

struct GetUserList {
	id          string     @[json: 'id']
	username    string     @[json: 'username']
	nickname    string     @[json: 'nickname']
	mobile      string     @[json: 'mobile']
	email       string     @[json: 'email']
	role_ids    []string   @[json: 'role_ids']
	avatar      string     @[json: 'avatar']
	status      u8         @[json: 'status']
	description string     @[json: 'description']
	home_path   string     @[json: 'home_path']
	position_id []string   @[json: 'position_id']
	created_at  time.Time  @[json: 'created_at']
	updated_at  time.Time  @[json: 'updated_at']
	deleted_at  ?time.Time @[json: 'deleted_at']
}
