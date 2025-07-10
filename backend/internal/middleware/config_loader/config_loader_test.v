module config_loader

// fn test_get_config() {
// 	mut loader1 := new_config_loader()
// 	doc := g_conf0.get_config()!
// 	dump('Web端口: ${doc.web.port}')
// 	// dump('数据库类型: ${doc.web.timeout}')
// 	assert typeof(doc.web.port).name == 'int'
// }

fn test_config_toml() {
	dump(config_toml())
	assert config_toml().len == 0
}

fn test_read_toml() {
	doc_toml := read_toml() // or { panic(err) }
	dump(doc_toml)
	// assert !isnil(doc_toml.ast.table)
}

fn test_parse_data() {
	global_config := parse_data()
	dump(global_config)
}
