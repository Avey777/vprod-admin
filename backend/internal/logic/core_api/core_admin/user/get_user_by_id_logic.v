module user

import veb
import log
import orm
import time
import x.json2 as json
import internal.structs.schema_core
import common.api
import internal.structs { Context }

@['/id'; post]
fn (app &User) user_by_id(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json.decode[UserByIdReq](ctx.req.data) or {
		return ctx.json(api.json_error_400(err.msg()))
	}

	result := user_by_id_resp(mut ctx, req) or { return ctx.json(api.json_error_500(err.msg())) }

	return ctx.json(api.json_success_200(result))
}

fn user_by_id_resp(mut ctx Context, req UserByIdReq) !UserByIdResp {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	db, conn := ctx.dbpool.acquire() or { return error('Failed to acquire connection: ${err}') }
	defer {
		ctx.dbpool.release(conn) or {
			log.warn('Failed to release connection ${@LOCATION}: ${err}')
		}
	}

	mut core_user := orm.new_query[schema_core.CoreUser](db)
	result := core_user.select()!.where('id = ?', req.user_id)!.query()!

	if result.len == 0 {
		return error('User not found')
	}

	user_data := result[0]

	// Get user roles
	mut user_role := sql db {
		select from schema_core.CoreRoleTenantMember where member_id == req.user_id
	}!

	mut user_role_ids := []string{}
	mut user_role_names := []string{}

	for row_urs in user_role {
		user_role_ids << row_urs.role_id

		// Get role names
		mut role := sql db {
			select from schema_core.CoreRole where id == row_urs.role_id
		}!
		for raw_name in role {
			user_role_names << raw_name.name
		}
	}

	// Create user data
	data := UserById{
		id:         user_data.id
		username:   user_data.username
		nickname:   user_data.nickname
		status:     user_data.status
		role_ids:   user_role_ids
		role_names: user_role_names
		avatar:     user_data.avatar or { '' }
		desc:       user_data.description or { '' }
		home_path:  user_data.home_path
		email:      user_data.email or { '' }
		creator_id: user_data.creator_id or { '' }
		updater_id: user_data.updater_id or { '' }
		created_at: user_data.created_at
		updated_at: user_data.updated_at
		deleted_at: user_data.deleted_at
	}

	return UserByIdResp{
		datalist: [data]
	}
}

struct UserByIdReq {
	user_id string
}

struct UserByIdResp {
	datalist []UserById
}

struct UserById {
	id         string     @[json: 'id']
	username   string     @[json: 'username']
	nickname   string     @[json: 'nickname']
	status     u8         @[json: 'status']
	role_ids   []string   @[json: 'role_ids']
	role_names []string   @[json: 'role_names']
	avatar     string     @[json: 'avatar']
	desc       string     @[json: 'desc']
	home_path  string     @[json: 'home_path']
	mobile     string     @[json: 'mobile']
	email      string     @[json: 'email']
	creator_id string     @[json: 'creator_id']
	updater_id string     @[json: 'updater_id']
	created_at time.Time  @[json: 'created_at']
	updated_at time.Time  @[json: 'updated_at']
	deleted_at ?time.Time @[json: 'deleted_at']
}
