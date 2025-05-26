module config

import internal.config

fn test_toml_load() {
	assert typeof(config.toml_load()).name == 'toml.Doc'
}

fn test_new_config_loader() {
	// 验证单例
	mut loader1 := config.new_config_loader()
	mut loader2 := config.new_config_loader()
	// dump('实例相等性验证: ${loader1 == loader2}') // 输出 true
	assert g_conf == loader1 // 输出 true
	assert g_conf == loader2 // 输出 true
	assert loader1 == loader2 // 输出 true
}

fn test_get_config() {
	mut loader1 := config.new_config_loader()
	doc := g_conf.get_config()!
	dump('Web端口: ${doc.web.port}')
	// dump('数据库类型: ${doc.web.timeout}')
	assert typeof(doc.web.port).name == 'int'
}
