module admin

import veb
import log
import common.api { json_success }
import internal.structs { Context }
import os

@['/'; get; post]
fn (app &Admin) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success(200, 'success', ''))
}
