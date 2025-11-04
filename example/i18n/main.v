module main

import os
import x.json2 as json
import veb

// ------------------------- Context -------------------------
pub struct Context {
	veb.Context
pub mut:
	extra map[string]string = map[string]string{}
	i18n  &I18nStore
}

// Helper：在 Context 上增加 t 方法
pub fn (ctx &Context) t(key string) string {
	lang := ctx.extra['lang'] or { ctx.i18n.default_lang }
	return ctx.i18n.t(lang, key)
}

// ------------------------- App -------------------------
pub struct App {
	veb.Middleware[Context]
pub mut:
	i18n &I18nStore
}

// ------------------------- I18nStore -------------------------
@[heap]
pub struct I18nStore {
pub:
	default_lang string
	dir          string
pub mut:
	translations map[string]map[string]string
	lang_cache   map[string]string
	mod_times    map[string]i64
}

// 创建 I18nStore
pub fn new_i18n_store(dir string, default_lang string) !&I18nStore {
	mut store := &I18nStore{
		dir:          dir
		default_lang: default_lang
		translations: map[string]map[string]string{}
		lang_cache:   map[string]string{}
		mod_times:    map[string]i64{}
	}
	store.load_translations()!
	return store
}

// 加载或刷新 JSON 文件
pub fn (mut s I18nStore) load_translations() ! {
	if !os.exists(s.dir) {
		return
	}
	for file in os.ls(s.dir)! {
		if !file.ends_with('.json') {
			continue
		}
		full_path := os.join_path(s.dir, file)
		mod_time := os.file_last_mod_unix(full_path)
		if file in s.mod_times && s.mod_times[file] == mod_time {
			continue
		}
		content := os.read_file(full_path)!
		data := json.decode[map[string]json.Any](content)!
		lang := file.replace('.json', '')
		s.translations[lang] = flatten_map(data, '')
		s.mod_times[file] = mod_time
	}
}

// 将嵌套 map 展平成点号路径 map
fn flatten_map(data map[string]json.Any, prefix string) map[string]string {
	mut result := map[string]string{}
	for k, v in data {
		full_key := if prefix == '' { k } else { '${prefix}.${k}' }
		match v {
			string {
				result[full_key] = v
			}
			map[string]json.Any {
				sub := flatten_map(v, full_key)
				for sk, sv in sub {
					result[sk] = sv
				}
			}
			else {}
		}
	}
	return result
}

// 查询翻译
pub fn (s &I18nStore) t(lang string, key string) string {
	selected := if lang in s.translations { lang } else { s.default_lang }
	if key in s.translations[selected] {
		return s.translations[selected][key]
	}
	if key in s.translations[s.default_lang] {
		return s.translations[s.default_lang][key]
	}
	return key
}

// ------------------------- Middleware -------------------------
pub fn i18n_middleware(mut ctx Context, mut store I18nStore) {
	// 动态加载 JSON
	store.load_translations() or { eprintln('failed to load i18n: ${err}') }

	lang_header := ctx.req.header.get(.accept_language) or { store.default_lang }

	// 使用缓存
	if lang := store.lang_cache[lang_header] {
		ctx.extra['lang'] = lang
	} else {
		lang := parse_accept_language(lang_header, store)
		ctx.extra['lang'] = lang
		store.lang_cache[lang_header] = lang
	}

	ctx.i18n = store
}

// 支持多语言优先级选择
fn parse_accept_language(header string, store &I18nStore) string {
	mut langs := []string{}
	for part in header.split(',') {
		code := part.split(';')[0].trim_space()
		langs << code
	}
	for l in langs {
		if l in store.translations {
			return l
		}
	}
	return store.default_lang
}

// ------------------------- 路由 -------------------------
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	msg := ctx.t('hello')
	welcome := ctx.t('welcome')
	success := ctx.t('common.success')
	return ctx.text('i18n: ${msg}\n${welcome}\n${success}')
}

// 调试路由：打印当前语言所有 key/value
@['/i18n/debug'; get]
pub fn (app &App) debug_i18n(mut ctx Context) veb.Result {
	mut lines := []string{}
	lang := ctx.extra['lang'] or { ctx.i18n.default_lang }
	translations := if lang in ctx.i18n.translations {
		ctx.i18n.translations[lang].clone()
	} else {
		map[string]string{}
	}
	for k, v in translations {
		lines << '${k} = ${v}'
	}
	return ctx.text(lines.join('\n'))
}

// ------------------------- Main -------------------------
fn main() {
	mut store := new_i18n_store('locales', 'en') or { panic(err) }

	mut app := &App{
		i18n: store
	}

	// 注册全局中间件
	app.Middleware.global_handlers << fn [mut store] (mut ctx Context) {
		i18n_middleware(mut ctx, mut store)
	}

	// 启动服务
	veb.run[App, Context](mut app, 9006)
}

// ------------------------- 测试 -------------------------
// curl -H "Accept-Language: en" http://localhost:9006/
// curl -H "Accept-Language: zh" http://localhost:9006/
// curl -H "Accept-Language: zh" http://localhost:9006/i18n/debug
