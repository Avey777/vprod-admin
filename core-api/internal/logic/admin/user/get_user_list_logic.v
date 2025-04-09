module user

import veb
import log
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

type Any = string | int | bool | []string | map[string]int | []map[string]string | []map[string]Any


@['/user_id'; get]
fn (app &User) index(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut result := get_user_list(1,3) or { return ctx.json(json_error(503, '${err}')) }
	return ctx.json(json_success('success', result))
}

pub fn get_user_list(page int ,page_size int)  !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }
	// 总页数查询
	mut count := sql db {
		select count from schema.SysUser
	} or {
		log.debug('select count from schema.SysUser 查询失败')
		return err
	}
	// 分页数据查询
	offset_num := (page - 1) * page_size
	mut result := sql db {
		select from schema.SysUser limit page_size offset offset_num
	} or {
		log.debug('result 查询失败')
		return err
	}

	mut datalist := []map[string]Any{} //map空数组初始化
 	for row in result {
		mut data := map[string]Any{} // map初始化
		data['id'] = '${row.id}' //主键ID
		data['Username'] = '${row.username}'
		data['Nickname'] = '${row.nickname}'
		data['Mobile'] = '${row.mobile}'
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_role := sql db {
		  select from schema.SysUserRole where user_id == row.id
		} or {return err}
		mut user_roles_ids_list := []string{} //map空数组初始化
		for row_urs in user_role { user_roles_ids_list << row_urs.role_id }
		data['RoleIds'] = user_roles_ids_list
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['Email'] = '${row.email}'
		data['Avatar'] = '${row.avatar}'
		data['Status'] = '${row.status}'
		data['Description'] = '${row.description}'
		data['HomePath'] = '${row.home_path}'
		data['DepartmentIds'] = '${row.department_id}'
		/*->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
		mut user_position := sql db {
		  select from schema.SysUserPosition where user_id == row.id
		} or {return err}
		mut user_position_ids_list := []string{} //map空数组初始化
		for row_ups in user_position { user_position_ids_list << row_ups.position_id }
		data['PositionIds'] = user_position_ids_list
		/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-*/
		data['CreatedAt'] = '${row.created_at}'
		data['UpdatedAt'] = '${row.updated_at}'
		data['DeletedAt'] = '${row.deleted_at}'

		datalist << data //追加data到maplist 数组
 	}

  mut result_data := map[string]Any{}
  result_data['total'] = count
  result_data['data'] = datalist

	return result_data
}


// The page request parameters | 列表请求参数
// swagger:model PageInfo
struct PageInfo {
	// Page number | 第几页,当前页码
	// required : true
	// min : 0
	page u64 @[json: 'page'; validate: 'required,number,gt=0']
	// Page size | 单页数据行数
	// required : true
	// max : 100000
	page_size u64 @[json: 'pageSize'; validate: 'required,number,lt=100000']
}

/***************************************************************************************************/
// 用户列表请求参数
// swagger:model UserListReq
pub struct UserListReq {
pub:
	// 分页信息
	// page_info PageInfo
	// 用户名 | User Name
	// 最大长度: 20 | max length: 20
	username ?string @[json: 'username,optional'; validate: 'omitempty,alphanum,max=20']

	// 用户昵称 | User's nickname
	// 最大长度: 10 | max length: 10
	nickname ?string @[json: 'nickname,optional'; validate: 'omitempty,alphanumunicode,max=10']

	// 手机号码 | User's mobile phone number
	// 最大长度: 18 | max length: 18
	mobile ?string @[json: 'mobile,optional'; validate: 'omitempty,eq=|numeric,max=18']

	// 邮箱地址 | User's email address
	// 最大长度: 100 | max length: 100
	email ?string @[json: 'email,optional'; validate: 'omitempty,email,max=100']

	// 角色ID列表 | User's role IDs
	role_ids []u64 @[json: 'roleIds,optional']

	// 部门ID | User's department ID
	department_id ?u64 @[json: 'departmentId,optional']

	// 职位ID | User's position ID
	position_id ?u64 @[json: 'positionId,optional']

}

// // 用户信息响应
// // swagger:model UserInfoResp
// pub struct UserInfoResp {
// pub:
// 	// 基础响应信息
// 	base_data []BaseDataInfo

// 	// 用户数据 | User information
// 	data []UserInfo @[json: 'data']
// }

// // The basic response with data | 基础带数据信息
// // swagger:model BaseDataInfo
// struct BaseDataInfo {
// 	// Error code | 错误代码
// 	code int @[json: 'code']
// 	// Message | 提示信息
// 	msg string @[json: 'msg']
// 	// Data | 数据
// 	data string @[json: 'data,omitempty']
// }

// // The response data of user information | 用户信息
// // swagger:model UserInfo
// struct UserInfo {
// 	// BaseUUIDInfo
// 	// Status | 状态
// 	// max : 20
// 	status &u32 @[json: 'status,optional'; validate: 'omitempty,lt=20']
// 	// Username | 用户名
// 	// max length : 50
// 	username &string @[json: 'username,optional'; validate: 'omitempty,max=50']
// 	// Nickname | 昵称
// 	// max length : 40
// 	nickname &string @[json: 'nickname,optional'; validate: 'omitempty,max=40']
// 	// Password | 密码
// 	// min length : 6
// 	password &string @[json: 'password,optional'; validate: 'omitempty,min=6']
// 	// Description | 描述
// 	// max length : 100
// 	description &string @[json: 'description,optional'; validate: 'omitempty,max=100']
// 	// HomePath | 首页
// 	// max length : 70
// 	homepath &string @[json: 'homePath,optional'; validate: 'omitempty,max=70']
// 	// RoleId | 角色ID
// 	roleids []u64 @[json: 'roleIds,optional']
// 	// Mobile | 手机号
// 	// max length : 18
// 	mobile &string @[json: 'mobile,optional'; validate: 'omitempty,max=18']
// 	// Email | 邮箱
// 	// max length : 80
// 	email &string @[json: 'email,optional'; validate: 'omitempty,max=80']
// 	// Avatar | 头像地址
// 	// max length : 300
// 	avatar &string @[json: 'avatar,optional'; validate: 'omitempty,max=300']
// 	// Department ID | 部门ID
// 	departmentid &u64 @[json: 'departmentId,optional,omitempty']
// 	// Position ID | 职位ID
// 	positionids []u64 @[json: 'positionId,optional,omitempty']
// }

/*****************************************************************************************/

// package user

// import (
// 	"context"

// 	"github.com/suyuan32/simple-admin-common/i18n"

// 	"github.com/suyuan32/simple-admin-core/api/internal/svc"
// 	"github.com/suyuan32/simple-admin-core/api/internal/types"
// 	"github.com/suyuan32/simple-admin-core/rpc/types/core"

// 	"github.com/zeromicro/go-zero/core/logx"
// )

// type GetUserListLogic struct {
// 	logx.Logger
// 	ctx    context.Context
// 	svcCtx *svc.ServiceContext
// }

// func NewGetUserListLogic(ctx context.Context, svcCtx *svc.ServiceContext) *GetUserListLogic {
// 	return &GetUserListLogic{
// 		Logger: logx.WithContext(ctx),
// 		ctx:    ctx,
// 		svcCtx: svcCtx,
// 	}
// }

// func (l *GetUserListLogic) GetUserList(req *types.UserListReq) (resp *types.UserListResp, err error) {
// 	data, err := l.svcCtx.CoreRpc.GetUserList(l.ctx, &core.UserListReq{
// 		Page:         req.Page,
// 		PageSize:     req.PageSize,
// 		Username:     req.Username,
// 		Nickname:     req.Nickname,
// 		Email:        req.Email,
// 		Mobile:       req.Mobile,
// 		RoleIds:      req.RoleIds,
// 		DepartmentId: req.DepartmentId,
// 		Description:  req.Description,
// 	})
// 	if err != nil {
// 		return nil, err
// 	}
// 	resp = &types.UserListResp{}
// 	for _, v := range data.Data {
// 		resp.Data.Data = append(resp.Data.Data, types.UserInfo{
// 			BaseUUIDInfo: types.BaseUUIDInfo{
// 				Id:        v.Id,
// 				CreatedAt: v.CreatedAt,
// 				UpdatedAt: v.UpdatedAt,
// 			},
// 			Username:     v.Username,
// 			Nickname:     v.Nickname,
// 			Mobile:       v.Mobile,
// 			RoleIds:      v.RoleIds,
// 			Email:        v.Email,
// 			Avatar:       v.Avatar,
// 			Status:       v.Status,
// 			Description:  v.Description,
// 			HomePath:     v.HomePath,
// 			DepartmentId: v.DepartmentId,
// 			PositionIds:  v.PositionIds,
// 		})
// 	}
// 	resp.Data.Total = data.Total
// 	resp.Msg = l.svcCtx.Trans.Trans(l.ctx, i18n.Success)
// 	return resp, nil
// }
