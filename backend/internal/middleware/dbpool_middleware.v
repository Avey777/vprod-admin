module middleware

import veb
import log
import time
import internal.config
import internal.structs { Context }
import internal.middleware.dbpool

// 初始化数据库连接池
pub fn init_db_pool() !&dbpool.DatabasePoolable {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	doc := config.toml_load()
	mut config_db := dbpool.DatabaseConfig{
		host:     doc.value('dbconf.host').string()
		port:     doc.value('dbconf.port').string().u32()
		username: doc.value('dbconf.username').string()
		password: doc.value('dbconf.password').string()
		dbname:   doc.value('dbconf.dbname').string()
		// ssl_ca:   doc.value('dbconf.ssl_ca').string()
		// flag: .client_ssl | .client_ssl_verify_server_cert
		/*pool 配置*/
		max_conns:      doc.value('dbconf.max_conns').int()
		min_idle_conns: doc.value('dbconf.min_idle_conns').int()
		max_lifetime:   doc.value('dbconf.max_lifetime').i64() * time.minute
		idle_timeout:   doc.value('dbconf.idle_timeout').i64() * time.minute
		get_timeout:    doc.value('dbconf.get_timeout').i64() * time.second
	}

	if doc.value('dbconf.ssl_verify').bool() == true {
		config_db.flag = .client_ssl | .client_ssl_verify_server_cert
		config_db.ssl_key = doc.value('dbconf.ssl_key').string()
		config_db.ssl_cert = doc.value('dbconf.ssl_cert').string()
		config_db.ssl_ca = doc.value('dbconf.ssl_ca').string()
		config_db.ssl_capath = doc.value('dbconf.ssl_capath').string()
		config_db.ssl_cipher = doc.value('dbconf.ssl_cipher').string()
	}
	// log.debug('${config_db}')
	mut conn := dbpool.new_db_pool(config_db) or {
		log.error('Mysql/TiDB数据库连接失败,请检查配置文件: ${config.config_toml()}: ${doc.value('dbconf')} : ${err}')
		return err
	}
	// log.debug('${conn}')
	log.debug(doc.value('dbconf.type').string() + '数据库连接成功')
	return conn
}

// 独立中间件生成函数
pub fn db_middleware(conn &dbpool.DatabasePoolable) veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: fn [conn] (mut ctx Context) bool {
			ctx.dbpool = unsafe { conn } //分配到堆上，需要使用 unsafe
			return true // 返回 true 表示继续处理请求
		}
	}
}
