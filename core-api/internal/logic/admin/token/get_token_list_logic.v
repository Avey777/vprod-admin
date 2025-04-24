module token

import veb
import log
import time
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

@['/list'; post]
fn (app &Token) token_list(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')
	// log.debug('ctx.req.data type: ${typeof(ctx.req.data).name}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := token_list_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn token_list_resp(req json2.Any)  !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	page := req.as_map()['page'] or {1}.int()
	page_size := req.as_map()['pageSize'] or {10}.int()
	username := req.as_map()['username'] or {''}.str()

	mut db := db_mysql()
	defer { db.close() }
	mut sys_token := orm.new_query[schema.SysToken](db)
	// 总页数查询 - 分页偏移量构造
	mut count := sql db { select count from schema.SysUser }!
	offset_num := (page - 1) * page_size
	//*>>>*/
	mut query := sys_token.select()!
  if username != '' {query = query.where('username = ?', username)!}
	result := query.limit(page_size)!.offset(offset_num)!.query()!
	//*<<<*/
	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
    mut data := map[string]Any{} // map初始化
		data['id'] = row.id //主键ID
		data['username'] = row.username
		data['token'] = row.token
		data['source'] = row.source
		data['expiredAt'] = row.expired_at.format_ss()
		data['status'] = int(row.status)
		data['createdAt'] = row.created_at.format_ss()
		data['updatedAt'] = row.updated_at.format_ss()
		data['deletedAt'] = row.deleted_at or {time.Time{}}.format_ss()

		datalist << data //追加data到maplist 数组
 	}

  mut result_data := map[string]Any{}
  result_data['total'] = count
  result_data['data'] = datalist

	return result_data
}
