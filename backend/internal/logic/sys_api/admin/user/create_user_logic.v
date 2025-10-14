module user

import veb
import log
import orm
import time
import x.json2
import rand
import internal.structs.schema_sys
import common.api
import internal.structs { Context }
import common.encrypt

// Create User | 创建用户
@['/create_user'; post]
fn (app &User) create_user(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.decode[json2.Any](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}
	mut result := create_user_resp(mut ctx, req) or {
		return ctx.json(api.json_error_500(err.msg()))
	}

	return ctx.json(api.json_success_200(result))
}

fn create_user_resp(mut ctx Context, req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	user_id := rand.uuid_v7() // req.as_map()['id'] or { '' }.str()
	position_ids := req.as_map()['position_ids'] or { []json2.Any{} }.arr()
	rule_ids := req.as_map()['rule_ids'] or { []json2.Any{} }.arr()
	password := req.as_map()['password'] or { '' }.str()
	client_hash := encrypt.bcrypt_hash(password) or { return error('Failed bcrypt_hash : ${err}') }

	users := schema_sys.SysUser{
		id:          user_id
		avatar:      req.as_map()['avatar'] or { '' }.str()
		description: req.as_map()['description'] or { '' }.str()
		email:       req.as_map()['email'] or { '' }.str()
		home_path:   req.as_map()['home_path'] or { '/dashboard' }.str()
		mobile:      req.as_map()['mobile'] or { '' }.str()
		nickname:    req.as_map()['nickname'] or { '' }.str()
		password:    client_hash
		status:      req.as_map()['status'] or { 0 }.u8()
		username:    req.as_map()['username'] or { '' }.str()
		created_at:  req.as_map()['created_at'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at:  req.as_map()['updated_at'] or { time.now() }.to_time()!
	}

	mut user_positions := []schema_sys.SysUserPosition{cap: position_ids.len}
	for raw in position_ids {
		user_positions << schema_sys.SysUserPosition{
			user_id:     user_id
			position_id: raw.str()
		}
	}

	mut user_roles := []schema_sys.SysUserRole{cap: rule_ids.len}
	for raw in rule_ids {
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
