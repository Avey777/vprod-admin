module routes

import veb
import log
import common.api
import internal.structs { Context }
import os

@['/get'; get]
pub fn (mut app AliasApp) get(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	dump(ctx.config)
	dump(ctx.config.web.port)
	return ctx.json(api.json_success(code: 200, data: 'req success'))
}

@['/static/403'; get; post]
fn (mut app AliasApp) index_403(mut ctx Context) veb.Result {
	file_path := os.join_path(os.getwd(), 'static/403.html')
	html_content := os.read_file(file_path) or {
		return ctx.html('<h1>403 Forbidden</h1><p>错误页面未找到</p>')
	}

	// 读取CSS文件并内联
	css_path := os.join_path(os.getwd(), 'static/styles.css')
	css_content := os.read_file(css_path) or { '' }

	// 将CSS内联到HTML中
	final_html := html_content.replace('</head>', '<style>${css_content}</style></head>')

	return ctx.html(final_html)
}

@['/static/404'; get; post]
fn (mut app AliasApp) index_404(mut ctx Context) veb.Result {
	file_path := os.join_path(os.getwd(), 'static/404.html')
	html_content := os.read_file(file_path) or {
		return ctx.html('<h1>404 Not Found</h1><p>错误页面未找到</p>')
	}

	// 读取CSS文件并内联
	css_path := os.join_path(os.getwd(), 'static/styles.css')
	css_content := os.read_file(css_path) or { '' }

	// 将CSS内联到HTML中
	final_html := html_content.replace('</head>', '<style>${css_content}</style></head>')

	return ctx.html(final_html)
}

@['/static/500'; get; post]
fn (mut app AliasApp) index_500(mut ctx Context) veb.Result {
	file_path := os.join_path(os.getwd(), 'static/500.html')
	html_content := os.read_file(file_path) or {
		return ctx.html('<h1>500 Internal Server Error</h1><p>服务器内部错误</p>')
	}

	// 读取CSS文件并内联
	css_path := os.join_path(os.getwd(), 'static/styles.css')
	css_content := os.read_file(css_path) or { '' }

	// 将CSS内联到HTML中
	final_html := html_content.replace('</head>', '<style>${css_content}</style></head>')

	return ctx.html(final_html)
}

@['/index'; get; post]
fn (mut app AliasApp) index(mut ctx Context) veb.Result {
	file_path := os.join_path(os.getwd(), 'static/index.html')
	html_content := os.read_file(file_path) or {
		return ctx.html('<h1>index Not Found</h1><p>index页面未找到</p>')
	}

	// 读取CSS文件并内联
	css_path := os.join_path(os.getwd(), 'static/styles.css')
	css_content := os.read_file(css_path) or { '' }

	// 将CSS内联到HTML中
	final_html := html_content.replace('</head>', '<style>${css_content}</style></head>')

	return ctx.html(final_html)
}
