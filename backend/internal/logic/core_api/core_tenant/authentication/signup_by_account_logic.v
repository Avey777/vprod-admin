module authentication

import veb
import log
import orm
import time
import x.json2 as json
import rand
import internal.structs.schema_core
import common.api
import internal.structs { Context }
import common.encrypt

// Create User | 创建用户
@['/create_user'; post]
fn (app &Authentication) create_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[CreateUserReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_user_resp(mut ctx Context, req CreateUserReq) !CreateUserResp {
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
	users := schema_core.CoreUser{
		id:          user_id
		avatar:      req.avatar
		description: req.description
		email:       req.email
		home_path:   req.home_path
		nickname:    req.nickname
		password:    client_hash
		status:      req.status
		username:    req.username
		created_at:  req.created_at
		updated_at:  req.updated_at
	}

	mut sys_user := orm.new_query[schema_core.CoreUser](db)
	sys_user.insert(users)!

	return CreateUserResp{
		msg: 'User created successfully'
	}
}

struct CreateUserReq {
	avatar      string    @[json: 'avatar']
	description string    @[json: 'description']
	email       string    @[json: 'email']
	home_path   string    @[json: 'home_path']
	nickname    string    @[json: 'nickname']
	password    string    @[json: 'password']
	status      u8        @[json: 'status']
	username    string    @[json: 'username']
	created_at  time.Time @[json: 'created_at']
	updated_at  time.Time @[json: 'updated_at']
}

struct CreateUserResp {
	msg string @[json: 'msg']
}
