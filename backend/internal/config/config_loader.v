module config

import log
import toml
import os

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
