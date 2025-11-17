module main

import veb
import log
import time
import internal.structs { Context }
import internal.middleware
import internal.config
import internal.i18n
import common.jwt
import internal.routes { AliasApp }

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	//*******init_config_loader********/
	log.debug('init_config_loader()')
	mut loader := config.new_config_loader()
	doc := loader.get_config() or { panic('Failed to load config: ${err}') }
	log.debug('${doc}')
	//********init_config_loader*******/

	i18n_app := i18n.new_i18n('./etc/locales', 'zh') or { return }

	//*******init_db_pool********/
	log.debug('init_db_pool()')
	mut conn := middleware.init_db_pool(doc) or {
		log.warn('db_pool 初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}
	//*******init_db_pool********/

	// 创建全局 Context
	mut ctx := &Context{
		dbpool:      conn
		config:      doc
		i18n:        i18n_app
		jwt_payload: jwt.JwtPayload{
			iss: 'vprod-workspase'
			sub: '0196b736-f807-73f0-8731-7a08c0ed75ea' // 用户唯一标识 (Subject)
			aud: ['api-service', 'webapp']
			exp: time.now().add_days(30).unix()
			nbf: time.now().unix()
			iat: time.now().unix()
			jti: '5907af3a-3f5a-4086-aaeb-68eca283d8d2' // JWT唯一标识 (JWT ID)，防重防攻击
			// 自定义业务字段 (Custom Claims)
			roles:     ['admin', 'editor']
			client_ip: '192.168.1.100'
			device_id: 'device-xyz'
		} // 根据你的 JwtPayload 结构初始化
	}

	mut app := &AliasApp{
		started: chan bool{cap: 1} // 关键：正确初始化通道
	} // 实例化 App 结构体 并返回指针

	// 路由控制器,仅作用于非子路由
	app.use(middleware.cores_middleware_generic())
	app.use(middleware.logger_middleware_generic())
	app.use(middleware.config_middle(ctx.config))
	app.use(middleware.db_middleware(ctx.dbpool))
	app.use(middleware.i18n_middleware(ctx.i18n))
	app.use(veb.encode_gzip[Context]())
	// 子路由控制器
	app.routes_ifdef(mut ctx)

	veb.run_at[AliasApp, Context](mut app,
		host:               ''
		port:               doc.web.port
		family:             .ip6
		timeout_in_seconds: doc.web.timeout
	) or { return }
}
