

// if *req.MenuType == 0 {
// 	req.Component = pointy.GetPointer("LAYOUT")
// 	req.Redirect = pointy.GetPointer("")
// 	req.FrameSrc = pointy.GetPointer("")

// MenuType:    req.MenuType,
// ParentId:    req.ParentId,
// Path:        req.Path,
// Name:        req.Name,
// Redirect:    req.Redirect,
// Component:   req.Component,
// Sort:        req.Sort,
// Disabled:    req.Disabled,
// ServiceName: req.ServiceName,
// Permission:  req.Permission,
// Meta: &core.Meta{
// 	Title:              req.Title,
// 	Icon:               req.Icon,
// 	HideMenu:           req.HideMenu,
// 	HideBreadcrumb:     req.HideBreadcrumb,
// 	IgnoreKeepAlive:    req.IgnoreKeepAlive,
// 	HideTab:            req.HideTab,
// 	FrameSrc:           req.FrameSrc,
// 	CarryParam:         req.CarryParam,
// 	HideChildrenInMenu: req.HideChildrenInMenu,
// 	Affix:              req.Affix,
// 	DynamicLevel:       req.DynamicLevel,
// 	RealPath:           req.RealPath,

//  id
// parent_id
// menu_level
// menu_type
// path
// name
// redirect
// component
// disabled
// service_name
// permission
// title
// icon
// hide_menu
// hide_breadcrumb
// ignore_keep_alive
// hide_tab
// frame_src
// carry_param
// hide_children_in_menu
// affix
// dynamic_level
// real_path
// sort

module menu

import veb
import log
import orm
import time
import x.json2
import rand
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Create menu | 创建Menu
@['/create_menu'; post]
fn (app &Menu) create_menu(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_menu_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_menu_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	menu := schema.SysMenu{
		id: rand.uuid_v7()
		// status:     req.as_map()['status'] or { 0 }.u8()
		name: req.as_map()['Name'] or { '' }.str()
		// code:       req.as_map()['Code'] or { '' }.str()
		// remark:     req.as_map()['Remark'] or { '' }.str()
		// sort:       req.as_map()['Sort'] or { 1 }.u64()
		created_at: req.as_map()['createdAt'] or { time.now() }.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
		updated_at: req.as_map()['updatedAt'] or { time.now() }.to_time()!
	}
	mut sys_menu := orm.new_query[schema.SysMenu](db)
	sys_menu.insert(menu)!

	return map[string]Any{}
}
