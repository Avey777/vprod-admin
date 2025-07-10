module handler

import veb
import log
import internal.structs { Context }
import internal.middleware.dbpool
import internal.middleware
import internal.middleware.config_loader

pub fn new_app() {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// doc := config.toml_load()

	log.info('init_config_loader()')
	mut loader := config_loader.new_config_loader()
	doc := loader.get_config() or { panic('Failed to load config: ${err}') }
	dump(doc)

	log.info('init_db_pool()')
	mut conn := init_db_pool(doc) or {
		log.info('初始化失败: ${err}')
		return
	}
	defer {
		conn.close()
	}

	mut app := &App{} // 实例化 App 结构体 并返回指针
	app.use(middleware.config_middle(doc))
	app.use(middleware.db_middleware(conn))

	app.register_handlers(conn, doc) // veb.Controller  使用路由控制器 | handler/register_routes.v

	veb.run_at[App, Context](mut app,
		host:               ''
		port:               doc.web.port
		family:             .ip6
		timeout_in_seconds: doc.web.timeout
	) or { return }
}



// 初始化数据库连接池
fn init_db_pool( doc &config_loader.GlobalConfig) !&dbpool.DatabasePool {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut config_db := dbpool.DatabaseConfig{
		host:     doc.dbconf.host
		port:     doc.dbconf.port.u32()
		username: doc.dbconf.username
		password: doc.dbconf.password
		dbname:   doc.dbconf.dbname
		// ssl_ca:   doc.value('dbconf.ssl_ca').string()
		// flag: .client_ssl | .client_ssl_verify_server_cert
		/*pool 配置*/
		max_conns:      doc.dbconf.max_conns
		min_idle_conns: doc.dbconf.min_idle_conns
		max_lifetime:   doc.dbconf.max_lifetime
		idle_timeout:   doc.dbconf.idle_timeout
		get_timeout:    doc.dbconf.get_timeout
	}

	if doc.dbconf.ssl_verify == true {
		config_db.flag = .client_ssl | .client_ssl_verify_server_cert
		config_db.ssl_key = doc.dbconf.ssl_key
		config_db.ssl_cert = doc.dbconf.ssl_cert
		config_db.ssl_ca = doc.dbconf.ssl_ca
		config_db.ssl_capath = doc.dbconf.ssl_capath
		config_db.ssl_cipher = doc.dbconf.ssl_cipher
	}
	// log.debug('${config_db}')
	mut conn := dbpool.new_db_pool(config_db) or {
		log.error('Mysql/TiDB数据库连接失败,请检查配置文件: ${config_loader.config_toml()}: ${doc.dbconf} : ${err}')
		return err
	}
	// log.debug('${conn}')
	log.debug(doc.dbconf.type + '数据库连接成功')
	return conn
}
