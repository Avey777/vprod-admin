module i18n

import os
import time
import x.json2 as json

// ------------------------- 测试 new_i18n -------------------------
fn test_new_i18n() {
	tmpdir := os.temp_dir()
	mut dir := os.join_path(tmpdir, 'i18n_test')
	os.mkdir_all(dir) or {}

	// 写入一个示例翻译文件
	os.write_file(os.join_path(dir, 'en.json'), '{"hello": "Hello"}') or {}

	i18n := new_i18n(dir, 'en') or {
		assert false, 'failed to create i18n store: ${err}'
		return
	}
	assert i18n.default_lang == 'en'
	assert 'hello' in i18n.translations['en']
	assert i18n.translations['en']['hello'] == 'Hello'
}

// ------------------------- 测试 maybe_reload -------------------------
fn test_maybe_reload() {
	tmpdir := os.temp_dir()
	mut dir := os.join_path(tmpdir, 'i18n_reload')
	os.mkdir_all(dir) or {}

	os.write_file(os.join_path(dir, 'en.json'), '{"hi": "Hi"}') or {}
	mut store := new_i18n(dir, 'en') or { panic(err) }

	// 等待后修改文件
	time.sleep(1001 * time.millisecond)
	os.write_file(os.join_path(dir, 'en.json'), '{"hi": "Hello again"}') or {}

	// 触发重新加载
	store.last_check = 0
	store.check_interval = 500
	maybe_reload(mut store)

	assert store.translations['en']['hi'] == 'Hello again'
}

// ------------------------- 测试 load_translations -------------------------
fn test_load_translations() {
	tmpdir := os.temp_dir()
	mut dir := os.join_path(tmpdir, 'i18n_load')
	os.mkdir_all(dir) or {}

	os.write_file(os.join_path(dir, 'zh.json'), '{"a": "你好"}') or {}
	mut store := &I18nStore{
		dir:          dir
		default_lang: 'zh'
	}
	load_translations(mut store) or { assert false, 'load_translations failed: ${err}' }
	assert 'a' in store.translations['zh']
	assert store.translations['zh']['a'] == '你好'
}

// ------------------------- 测试 t (翻译查询) -------------------------
fn test_t() {
	mut store := &I18nStore{
		default_lang: 'en'
		translations: {
			'en': {
				'hello': 'Hello'
			}
			'zh': {
				'hello': '你好'
			}
		}
	}
	assert store.t('zh', 'hello') == '你好'
	assert store.t('en', 'hello') == 'Hello'
	assert store.t('es', 'hello') == 'Hello' // fallback to default_lang
	assert store.t('en', 'not_exist') == 'not_exist'
}

// ------------------------- 测试 flatten_map -------------------------
fn test_flatten_map() {
	raw := {
		'greeting': json.Any({
			'morning': json.Any('Good morning')
			'nested':  json.Any({
				'deep': json.Any('Deep value')
			})
		})
	}
	result := flatten_map(raw, '')
	assert result['greeting.morning'] == 'Good morning'
	assert result['greeting.nested.deep'] == 'Deep value'
	assert result.len == 2
}
