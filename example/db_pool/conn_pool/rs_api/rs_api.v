module rs_api

import veb
import log
import api { Context }

pub struct Base {
	veb.Middleware[Context]
}

@['/index']
fn (mut app Base) get_user(mut ctx Context) veb.Result {
	log.info('4645646')
	// 使用上下文中的连接池
	mut db, conn := ctx.db_pool.acquire() or { return ctx.text('获取连接失败: ${err}') }

	defer {
		ctx.db_pool.release(conn) or { eprintln('释放连接失败: ${err}') }
	}

	// query := 'SELECT * FROM sys_users WHERE id = 1'
	// rows := db.exec(query) or { return ctx.text('查询失败: ${err}') }

	sql db {
		create table SysUser
	} or { panic(err) }
	rows := sql db {
		select from SysUser
	} or { panic(err) }

	return ctx.text(rows.str())
}

@[comment: ' 用户表']
@[table: 'sys_users']
struct SysUser {
	id       string @[comment: 'UUID rand.uuid_v4()'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	username string @[comment: 'User`s login name | 登录名'; omitempty; required; sql: 'username'; sql_type: 'VARCHAR(255)'; unique: 'username']
	password string @[comment: 'Password | 密码'; omitempty; required; sql: 'password'; sql_type: 'VARCHAR(255)']
	status   u8     @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
}
