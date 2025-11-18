module user

import veb
import log
import orm
import time
import x.json2 as json
import structs.schema_sys
import common.api
import structs { Context }

@['/update_user'; post]
fn (app &User) update_user_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UpdateUserReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := update_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn update_user_resp(mut ctx Context, req UpdateUserReq) !UpdateUserResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut user_positions := []schema_sys.SysUserPosition{cap: req.position_ids.len}
	for position_id in req.position_ids {
		user_positions << schema_sys.SysUserPosition{
			user_id:     req.user_id
			position_id: position_id
		}
	}

	mut user_roles := []schema_sys.SysUserRole{cap: req.role_ids.len}
	for role_id in req.role_ids {
		user_roles << schema_sys.SysUserRole{
			user_id: req.user_id
			role_id: role_id
		}
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut user_position := orm.new_query[schema_sys.SysUserPosition](db)
	mut user_role := orm.new_query[schema_sys.SysUserRole](db)

	sys_user.set('avatar = ?', req.avatar)!
		.set('email = ?', req.email)!
		.set('mobile = ?', req.mobile)!
		.set('nickname = ?', req.nickname)!
		.set('department_id = ?', req.department_id)!
		.set('description = ?', req.description)!
		.set('home_path = ?', req.home_path)!
		.set('password = ?', req.password)!
		.set('status = ?', req.status)!
		.set('username = ?', req.username)!
		.set('updated_at = ?', req.updated_at)!
		.where('id = ?', req.user_id)!
		.update()!

	user_position.delete()!.where('user_id = ?', req.user_id)!
		.insert_many(user_positions)!

	user_role.delete()!.where('user_id = ?', req.user_id)!
		.insert_many(user_roles)!

	return UpdateUserResp{
		msg: 'User updated successfully'
	}
}

struct UpdateUserReq {
	user_id       string    @[json: 'user_id']
	position_ids  []string  @[json: 'position_ids']
	role_ids      []string  @[json: 'role_ids']
	avatar        string    @[json: 'avatar']
	department_id string    @[json: 'department_id']
	description   string    @[json: 'description']
	email         string    @[json: 'email']
	home_path     string    @[json: 'home_path']
	mobile        string    @[json: 'mobile']
	nickname      string    @[json: 'nickname']
	password      string    @[json: 'password']
	status        u8        @[default: 0; json: 'status']
	username      string    @[json: 'username']
	updated_at    time.Time @[json: 'updated_at']
}

struct UpdateUserResp {
	msg string @[json: 'msg']
}
