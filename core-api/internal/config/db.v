module config

import log
import toml
import db.mysql

const file_name = 'config.toml'

//检查mysql数据库连接
pub fn database_mysql() !mysql.DB {
	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	log.info('开始连接mysql数据库')
	doc := toml.parse_file(file_name) or {
		log.error('config.toml文件不存在')
		return err
	}
	// dsn := 'xfQRtLXKTtPHsUi.root:GkFU6Q3uvt0O9F0A@tcp(gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000)/pool_1688?tls=true&sslmode=require&sslca=cart.pem'
	config := mysql.Config{
		host:     doc.value('mysql.host').string()
		port:     doc.value('mysql.port').string().u32()
		username: doc.value('mysql.username').string()
		password: doc.value('mysql.password').string()
		dbname:   doc.value('mysql.dbname').string()
		flag:     .client_ssl // flag: .client_ssl
	}

	mut conn := mysql.connect(config) or {
		log.error('mysql数据库连接失败:${doc.value('mysql')}')
		return err
	}
	log.info('mysql数据库连接成功')
	return conn
}
