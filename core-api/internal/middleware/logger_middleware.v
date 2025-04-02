module middleware

import log
import internal.structs { Context }

//日志中间件
pub fn logger_middleware(mut ctx Context) bool {
	// $if trace_before_request ? {
	log.info('[veb] trace_before_request: ${ctx.req.method} ${ctx.req.url}')
	// }
	return true
}
