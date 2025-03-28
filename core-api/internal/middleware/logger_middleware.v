module middleware

import log
import veb

pub struct Context {
	veb.Context
}

//日志中间件（未知原因：对 register_controller 的路由不生效）
pub fn logger_middleware(mut ctx Context) bool {
	// $if trace_before_request ? {
	log.info('[veb] trace_before_request: ${ctx.req.method} ${ctx.req.url}')
	// }
	return true
}
