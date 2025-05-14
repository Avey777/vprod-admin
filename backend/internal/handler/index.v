module handler

import veb
import log
import common.api { json_success }
import internal.structs { Context }

// 此方法将仅处理对 index 页面的GET请求 ｜ This method will only handle GET requests to the index page
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success('req success', ''))
}
