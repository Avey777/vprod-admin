module config

import internal.config

fn test_toml_load() {
	assert typeof(config.toml_load()).name == 'toml.Doc'
}
