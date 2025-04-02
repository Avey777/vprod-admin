module admin

import veb
import log
import internal.structs { json_success }
// import internal.config
// import internal.structs.schema

@['/router'; get]
fn (app &Admin) index(mut ctx structs.Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.info('[veb] before_request: ${ctx.req.method} ${ctx.req.url} ')
	return ctx.json(json_success('success', ''))
}
