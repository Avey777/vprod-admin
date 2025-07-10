module handler

import log
import internal.middleware.conf

// 配置文件设置日志级别
pub fn log_set_sevel() ! {
	doc := conf.read_toml() or { panic(err) }
	// 获取TOML中的log_level字符串值

	log_level_str := doc.value('logging.log_level').string()
	log.warn(log_level_str)
	// 将字符串转换为log.Level枚举值
	level := match log_level_str.to_lower() {
		'debug' { log.Level.debug }
		'info' { log.Level.info }
		'warn' { log.Level.warn }
		'error' { log.Level.error }
		'fatal' { log.Level.fatal }
		else { log.Level.info } // 设置默认值
	}
	log.set_level(level)
}

// 编译时设置日志级别 [v -d log_debug run . -f 'etc/config_dev.toml']
@[deprecated: '2025-05-26']
pub fn log_sevel() {
	$if log_debug ? {
		log.set_level(.debug)
	}
	$if log_info ? {
		log.set_level(.info)
	}
	$if log_warn ? {
		log.set_level(.warn)
	}
	$if log_error ? {
		log.set_level(.error)
	}
	$if log_fatal ? {
		log.set_level(.fatal)
	}
}
