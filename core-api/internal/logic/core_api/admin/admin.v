module admin

import veb
import log
import internal.structs { Context, json_success }
// import internal.config
// import internal.structs.schema

@['/router'; get]
fn (app &Admin) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	return ctx.json(json_success('success', ''))
}
