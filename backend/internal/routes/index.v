module routes

import veb
import log
import common.api
import internal.structs { Context }
import os

@['/index'; get; post]
pub fn (mut app AliasApp) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	dump(ctx.config)
	dump(ctx.config.web.port)
	return ctx.json(api.json_success(200, 'req success', ''))
}

@['/error/403'; get; post]
fn (mut app AliasApp) index_403(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	file_path := os.join_path(os.getwd(), 'static/403.html')
	log.debug('尝试读取文件: ${file_path}')
	log.debug('当前工作目录: ${os.getwd()}')
	log.debug('文件是否存在: ${os.exists(file_path)}')

	content := os.read_file(file_path) or {
		log.error('无法读取文件: ${file_path}, 错误: ${err}')

		// 列出当前目录文件来调试
		files := os.ls(os.getwd()) or { [] }
		log.error('当前目录文件列表: ${files}')

		return ctx.html('<h1>403 Forbidden</h1><p>错误页面未找到</p>')
	}

	log.debug('成功读取文件，长度: ${content.len}')
	return ctx.html(content)
}
