module middleware

import veb
import log
import internal.structs { Context }
import internal.i18n

pub fn i18n_middleware(i18n_app &i18n.I18nStore) veb.MiddlewareOptions[Context] {
	return veb.MiddlewareOptions[Context]{
		handler: fn [i18n_app] (mut ctx Context) bool {
			// 绑定 i18n
			ctx.i18n = i18n_app
			i18n.maybe_reload(mut ctx.i18n)

			// 获取语言
			lang_header := ctx.req.header.get(.accept_language) or { ctx.i18n.default_lang }

			if lang := ctx.i18n.lang_cache[lang_header] {
				ctx.extra_i18n['lang'] = lang
			} else {
				lang := parse_accept_language(lang_header, ctx.i18n)
				ctx.extra_i18n['lang'] = lang
				ctx.i18n.lang_cache[lang_header] = lang
			}

			return true // 允许继续处理
		}
	}
}

fn parse_accept_language(header string, s &i18n.I18nStore) string {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	for part in header.split(',') {
		code := part.split(';')[0].trim_space()
		if code in s.translations.keys() {
			return code
		}
	}
	return s.default_lang
}
