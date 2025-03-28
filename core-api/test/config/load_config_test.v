module config

import internal.config

fn test_toml_load() {
	// doc_toml := config.read_toml()!
	assert typeof(config.toml_load()!).name == 'toml.Doc'
}
