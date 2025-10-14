module api

import veb
import log
import common.api
import internal.structs { Context }

@['/api'; get]
pub fn (mut app Api) get(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	dump(ctx.config)
	dump(ctx.config.web.port)
	return ctx.json(api.json_success(200, 'req success', ''))
}
