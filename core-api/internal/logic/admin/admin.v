module admin

import veb
import log
import internal.structs { json_success }
// import internal.handler

@['/router'; get]
fn (app &Admin) index(mut ctx Context) veb.Result {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success(2, 'success'))
}
