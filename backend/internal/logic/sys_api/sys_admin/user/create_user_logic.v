module user

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }
import common.encrypt

// Create User | 创建用户
@['/create_user'; post]
fn (app &User) create_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateUserReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_user_resp(mut ctx Context, req CreateUserReq) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	user_id := rand.uuid_v7()
	client_hash := encrypt.bcrypt_hash(req.password) or {
		return error('Failed bcrypt_hash : ${err}')
	}
	users := schema_sys.SysUser{
		id:          user_id
		avatar:      req.avatar
		description: req.description
		email:       req.email
		home_path:   req.home_path
		mobile:      req.mobile
		nickname:    req.nickname
		password:    client_hash
		status:      req.status
		username:    req.username
		created_at:  req.created_at
		updated_at:  req.updated_at
	}

	mut user_positions := []schema_sys.SysUserPosition{cap: req.position_ids.len}
	for raw in req.position_ids {
		user_positions << schema_sys.SysUserPosition{
			user_id:     user_id
			position_id: raw.str()
		}
	}

	mut user_roles := []schema_sys.SysUserRole{cap: req.role_ids.len}
	for raw in req.role_ids {
		user_roles << schema_sys.SysUserRole{
			user_id: user_id
			role_id: raw.str()
		}
	}

	mut sys_user := orm.new_query[schema_sys.SysUser](db)
	mut user_position := orm.new_query[schema_sys.SysUserPosition](db)
	mut user_role := orm.new_query[schema_sys.SysUserRole](db)

	sys_user.insert(users)!
	user_position.insert_many(user_positions)!
	user_role.insert_many(user_roles)!

	return map[string]Any{}
}

struct CreateUserReq {
	avatar       string    @[json: 'avatar']
	description  string    @[json: 'description']
	mobile       string    @[json: 'mobile']
	email        string    @[json: 'email']
	home_path    string    @[json: 'home_path']
	nickname     string    @[json: 'nickname']
	password     string    @[json: 'password']
	status       u8        @[json: 'status']
	username     string    @[json: 'username']
	position_ids []string  @[json: 'position_ids']
	role_ids     []string  @[json: 'role_ids']
	created_at   time.Time @[json: 'created_at']
	updated_at   time.Time @[json: 'updated_at']
}

struct CreateUserResp {
	msg string @[json: 'msg']
}
