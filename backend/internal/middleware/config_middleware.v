module middleware

import veb
import internal.structs { Context }
import internal.middleware.config_loader

// 配置中间件 - 将全局配置注入请求上下文
pub fn config_middle(config &config_loader.GlobalConfig) veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: fn [config] (mut ctx Context) bool {
			ctx.config = config
			return true
		}
	}
}
