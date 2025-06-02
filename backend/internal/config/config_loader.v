module config

import log
import toml
import os
import sync

//指定配置文件 [v run . -f 'etc/config_dev.toml']
pub fn config_toml() string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	mut cf_toml := os.join_path('.', 'etc', 'config.toml') // 默认值前置，使用跨平台路径拼接
	args := os.args[1..]
	for i in 0 .. args.len {
		if args[i] == '-f' {
			if i + 1 >= args.len {
				log.error('错误：-f 参数后缺少文件名; ${@METHOD} ${@MOD}.${@FILE_LINE}') // 直接终止并报错
			}
			cf_toml = args[i + 1]
			break
		}
	}
	log.debug('toml配置文件路径：' + os.join_path(os.getwd(), cf_toml))
	return cf_toml
}

// 仅在数据检查时使用
// @[deprecated: '2025-05-26']
pub fn toml_load() toml.Doc {
	log.debug('准备读取${config_toml()}配置 ${@METHOD}  ${@MOD}.${@FILE_LINE}')

	doc_toml := toml.parse_file(config_toml()) or {
		log.error('${config_toml()} 文件不存在; ${@METHOD}  ${@MOD}.${@FILE_LINE}')
		return toml.Doc{}
	}
	log.debug('${config_toml()} 读取成功：' + typeof(doc_toml).name)
	return doc_toml
}

/*
配置加载器
在main文件引用，APP启动时初始化
后续的配置内容从全局变量里获取
避免频繁进行 IO
*/
//>>>>>>>>>>>>>配置加载器>>>>>>>>>>>>>>>>>>
@[heap]
struct ConfigLoader {
mut:
	config   &Config = unsafe { nil } // 存储配置对象的指针
	load_err IError  = none           // 加载错误信息
	once     &sync.Once // 保证线程安全的单次加载
}

// 全局配置加载器实例config_toml
__global g_conf ConfigLoader

// 创建配置加载器实例（单例模式）
pub fn new_config_loader() &ConfigLoader {
	mut g_conf_loader := &g_conf
	// 初始化同步控制器，确保配置只加载一次
	g_conf_loader.once = sync.new_once()
	return g_conf_loader
}

// 获取配置（带错误处理）
pub fn (mut cl ConfigLoader) get_config() !&Config {
	// 保证配置加载只会执行一次
	cl.once.do(cl.load_config)
	// 检查错误状态
	if cl.load_err is none {
		return cl.config
	}
	return cl.load_err
}

// 实际加载配置的方法
pub fn (mut cl ConfigLoader) load_config() {
	// 根据编译条件选择配置文件路径
	path := $if test { './etc/config.toml' } $else { config_toml() }
	// 解析TOML文件（示例配置结构需要与实际配置文件匹配）
	doc := toml.parse_file(path) or {
		cl.load_err = error('配置加载失败: ${err.msg()}')
		return
	}
	// 解析web配置节
	web_config := WebConf{
		port:    doc.value('web.port').int()
		timeout: doc.value('web.timeout').int()
	}
	//解析logging配置节
	log_config := LogConf{
		log_level: doc.value('logging.log_level').string()
	}
	// // 解析dbconf配置节
	db_config := DBConf{
		type:       doc.value('dbconf.type').string()
		host:       doc.value('dbconf.host').string()
		port:       doc.value('dbconf.port').string()
		username:   doc.value('dbconf.username').string()
		password:   doc.value('dbconf.password').string()
		ssl_verify: doc.value('dbconf.ssl_verify').bool()
		ssl_key:    doc.value('dbconf.ssl_key').string()
		ssl_cert:   doc.value('dbconf.ssl_cert').string()
		ssl_ca:     doc.value('dbconf.ssl_ca').string()
		ssl_capath: doc.value('dbconf.ssl_capath').string()
		ssl_cipher: doc.value('dbconf.ssl_cipher').string()
	}
	// 构建完整配置对象
	cl.config = &Config{
		web:        web_config
		logging:    log_config
		dbconf: db_config
	}
}

//<<<<<<<<<<<<<<<配置加载器<<<<<<<<<<<<<<<<<<
