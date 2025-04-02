module admin

import veb
import log
import structt

@['/router'; get]
fn (app &Admin) index(mut ctx structt.Context) veb.Result {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	return ctx.json('admin success')
}
