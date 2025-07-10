/*
配置加载器
在main文件引用，APP启动时初始化
避免频繁进行 IO
*/

module config_loader

import toml
import sync
import log
import os

@[heap]
pub struct ConfigLoader {
pub mut:
	globalconfig &GlobalConfig = unsafe { nil } // 存储配置对象的指针
	once         sync.Once // 保证线程安全的单次加载
}

// 创建新的配置加载器实例
pub fn new_config_loader() &ConfigLoader {
	return &ConfigLoader{}
}

// 获取配置（带错误处理）
pub fn (mut cl ConfigLoader) get_config() !&GlobalConfig {
	cl.once.do(fn [mut cl] () {
		global_config := parse_data() or { return }
		cl.globalconfig = &global_config
	})
	return cl.globalconfig
}

// 解析toml文件
pub fn parse_data() !GlobalConfig {
	doc := read_toml()!
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
		dbname:     doc.value('dbconf.dbname').string()
		ssl_verify: doc.value('dbconf.ssl_verify').bool()
		ssl_key:    doc.value('dbconf.ssl_key').string()
		ssl_cert:   doc.value('dbconf.ssl_cert').string()
		ssl_ca:     doc.value('dbconf.ssl_ca').string()
		ssl_capath: doc.value('dbconf.ssl_capath').string()
		ssl_cipher: doc.value('dbconf.ssl_cipher').string()
		// 连接池配置
		max_conns:      doc.value('dbconf.max_conns').int() // 默认 100 个
		min_idle_conns: doc.value('dbconf.min_idle_conns').int() // 默认 10个
		max_lifetime:   doc.value('dbconf.max_lifetime').int() // 默认 60 minute
		idle_timeout:   doc.value('dbconf.idle_timeout').int() // 默认 30 minute
		get_timeout:    doc.value('dbconf.get_timeout').int() // 默认 3 second
	}
	// 构建完整配置对象
	return GlobalConfig{
		web:     web_config
		logging: log_config
		dbconf:  db_config
	}
}

fn read_toml() !toml.Doc {
	// 提供默认路径和备用路径
	mut paths := $if test {
		[
			os.join_path(@VMODROOT, 'etc', 'config_dev.toml'),
			os.join_path(@VMODROOT, 'etc', 'config_test.toml'),
			os.join_path(@VMODROOT, 'etc', 'config.toml'),
		]
	} $else {
		[
			config_toml(),
			os.join_path(@VMODROOT, config_toml()), //优先指定配置文件
			os.join_path(@VMODROOT, 'config.toml'),
			os.join_path(@VMODROOT, 'etc', 'config.toml'),
		]
	}

	for path in paths {
		doc := toml.parse_file(path) or {
			log.warn('配置文件未找到-跳过继续: ${err.msg()}')
			continue
		}
		return doc
	}

	// 所有路径都尝试失败后终止
	log.fatal('配置文件未找到，尝试路径: ${paths.join(', ')}')
}

//指定配置文件 [v run . -f 'etc/config_dev.toml']
pub fn config_toml() string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut cf_toml := os.join_path('')
	args := os.args[1..]
	for i in 0 .. args.len {
		if args[i] == '-f' {
			if i + 1 >= args.len {
				log.fatal('错误：-f 参数后缺少文件名; ${@METHOD} ${@MOD}.${@FILE_LINE}') // 直接终止并报错
			}
			cf_toml = args[i + 1]
			break
		}
	}
	log.debug('toml配置文件路径：${cf_toml}')
	return cf_toml
}
