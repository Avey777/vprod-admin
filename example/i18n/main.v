module main

import os
import json
import veb

pub struct Context {
	veb.Context
pub mut:
	extra map[string]string = map[string]string{}
	i18n  &I18nStore
}

pub struct App {
	// 嵌入中间件功能
	veb.Middleware[Context]
pub mut:
	i18n &I18nStore
}

// Helper：在 Context 上增加 t 方法
pub fn (ctx &Context) t(key string) string {
	lang := ctx.extra['lang'] or { ctx.i18n.default_lang }
	return ctx.i18n.t(lang, key)
}

// I18nStore
@[heap]
pub struct I18nStore {
pub:
	default_lang string
pub mut:
	translations map[string]map[string]string
}

pub fn new_i18n_store(dir string, default_lang string) !&I18nStore {
	mut translations := map[string]map[string]string{}
	if !os.exists(dir) {
		return &I18nStore{
			translations: translations
			default_lang: default_lang
		}
	}
	for file in os.ls(dir)! {
		if !file.ends_with('.json') {
			continue
		}
		lang := file.replace('.json', '')
		content := os.read_file(os.join_path(dir, file))!
		data := json.decode(map[string]string, content)!
		translations[lang] = data.clone()
	}
	return &I18nStore{
		translations: translations
		default_lang: default_lang
	}
}

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

// Middleware
pub fn i18n_middleware(mut ctx Context, store &I18nStore) {
	lang_header := ctx.req.header.get(.accept_language) or { store.default_lang }
	lang := parse_accept_language(lang_header, store)
	ctx.extra['lang'] = lang
	ctx.i18n = store
}

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

// 路由处理函数
@['/'; get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	msg := ctx.t('hello')
	welcome := ctx.t('welcome')
	success := ctx.t('common.success')
	return ctx.text('i18n: ${msg}\n${welcome}\n${success}')
}

// Main
fn main() {
	mut store := new_i18n_store('locales', 'en') or { panic(err) }

	mut app := &App{
		i18n: store
	}

	// 注册全局中间件
	app.Middleware.global_handlers << fn [store] (mut ctx Context) {
		i18n_middleware(mut ctx, store)
	}

	// 启动服务
	veb.run[App, Context](mut app, 9006)
}

// curl -H "Accept-Language: en" http://localhost:9006/
// curl -H "Accept-Language: zh" http://localhost:9006/
