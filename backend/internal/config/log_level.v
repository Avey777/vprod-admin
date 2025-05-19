module config

import log

//设置日志级别 [v -d log_debug run . -f 'etc/config_dev.toml']
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
