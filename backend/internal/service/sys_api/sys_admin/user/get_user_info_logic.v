module user

import veb
import log
import orm
import x.json2 as json
import internal.structs.schema_sys
import common.api
import internal.structs { Context }

@['/info'; get]
fn (app &User) user_info(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[GetUserInfoReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := user_info_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn user_info_resp(mut ctx Context, req GetUserInfoReq) !GetUserInfoResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	// 查询特定用户信息
	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	users := sys_user.select()!.where('id = ?', req.user_id)!.query()!

	if users.len == 0 {
		return error('User not found')
	}

	user := users[0]

	// 查询用户角色
	user_roles := sql db {
		select from schema_sys.SysUserRole where user_id == req.user_id
	}!

	mut user_role_ids := []string{}
	for user_role in user_roles {
		user_role_ids << user_role.role_id
	}

	// 查询角色名称
	mut user_role_names := []string{}
	if user_role_ids.len > 0 {
		roles := sql db {
			select from schema_sys.SysRole where id in user_role_ids
		}!
		for role in roles {
			user_role_names << role.name
		}
	}

	// 查询部门信息 - 从关联表查询
	mut department_info := ''
	user_departments := sql db {
		select from schema_sys.SysUserDepartment where user_id == req.user_id
	}!

	if user_departments.len > 0 {
		department_id := user_departments[0].department_id
		departments := sql db {
			select from schema_sys.SysDepartment where id == department_id
		}!
		if departments.len > 0 {
			department_info = departments[0].name
		}
	}

	return GetUserInfoResp{
		user_id:         user.id
		username:        user.username
		nickname:        user.nickname
		avatar:          user.avatar or { '' }
		desc:            user.description or { '' }
		home_path:       user.home_path
		department_info: department_info
		role_names:      user_role_names
	}
}

struct GetUserInfoReq {
	user_id string @[json: 'user_id']
}

struct GetUserInfoResp {
	user_id         string   @[json: 'user_id']
	username        string   @[json: 'username']
	nickname        string   @[json: 'nickname']
	avatar          string   @[json: 'avatar']
	desc            string   @[json: 'desc']
	home_path       string   @[json: 'home_path']
	department_info string   @[json: 'department_info']
	role_names      []string @[json: 'role_names'] // 添加角色名称字段
}
