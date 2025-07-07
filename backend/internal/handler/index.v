module handler

import veb
import log
import common.api { json_success }
import internal.structs { Context }
import internal.structs.schema_sys

// 此方法将仅处理对 index 页面的GET请求 ｜ This method will only handle GET requests to the index page
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success('req success', ''))
}

@['/index2'; get]
pub fn (app &App) index2(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	mut db, conn := ctx.dbpool.acquire() or { return ctx.text('获取连接失败: ${err}') }
	defer {
		ctx.dbpool.release(conn) or { log.warn('释放连接失败: ${err}') }
	}
	mut rows := sql db {
		select from schema_sys.SysUser
	} or { return ctx.text('${@LOCATION}: ${err}') }
	dump(rows)
	return ctx.text(rows.str())
}
