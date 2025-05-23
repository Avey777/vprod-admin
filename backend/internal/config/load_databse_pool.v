module config

// import log
// import db.mysql

// //连接Mysql/TiDB数据库
// pub fn new_pool() mysql.ConnectionPool {
// 	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

// 	doc := toml_load()
// 	mut mysql_config := mysql.Config{
// 		host:     doc.value('dbconf.host').string()
// 		port:     doc.value('dbconf.port').string().u32()
// 		username: doc.value('dbconf.username').string()
// 		password: doc.value('dbconf.password').string()
// 		dbname:   doc.value('dbconf.dbname').string()
// 		// ssl_ca:   doc.value('dbconf.ssl_ca').string()
// 		// flag: .client_ssl | .client_ssl_verify_server_cert
// 	}
// 	if doc.value('dbconf.ssl_verify').bool() == true {
// 		mysql_config.flag = .client_ssl | .client_ssl_verify_server_cert
// 		mysql_config.ssl_key = doc.value('dbconf.ssl_key').string()
// 		mysql_config.ssl_cert = doc.value('dbconf.ssl_cert').string()
// 		mysql_config.ssl_ca = doc.value('dbconf.ssl_ca').string()
// 		mysql_config.ssl_capath = doc.value('dbconf.ssl_capath').string()
// 		mysql_config.ssl_cipher = doc.value('dbconf.ssl_cipher').string()
// 	}
// 	log.debug('${mysql_config}')

// 	log.debug('正在连接数据库...')
// 	mut conn := mysql.new_connection_pool(mysql_config, 5) or {
// 		log.error('Mysql/TiDB数据库连接失败,请检查配置文件: ${config_toml()}: ${doc.value('dbconf')} : ${err}')
// 		return mysql.ConnectionPool{}
// 	}

// 	log.debug('${conn}')
// 	log.debug(doc.value('dbconf.type').string() + '数据库连接成功')
// 	return conn
// }
