module middleware

import veb
import internal.structs { Context }
import internal.middleware.conf

// 配置中间件 - 将全局配置注入请求上下文
pub fn config_middle(config &conf.GlobalConfig) veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: fn [config] (mut ctx Context) bool {
			ctx.config = config
			return true
		}
	}
}
