// package token

// import (
// 	"context"

// 	"github.com/suyuan32/simple-admin-core/api/internal/svc"
// 	"github.com/suyuan32/simple-admin-core/api/internal/types"
// 	"github.com/suyuan32/simple-admin-core/rpc/types/core"

// 	"github.com/zeromicro/go-zero/core/logx"
// )

// type CreateTokenLogic struct {
// 	logx.Logger
// 	ctx    context.Context
// 	svcCtx *svc.ServiceContext
// }

// func NewCreateTokenLogic(ctx context.Context, svcCtx *svc.ServiceContext) *CreateTokenLogic {
// 	return &CreateTokenLogic{
// 		Logger: logx.WithContext(ctx),
// 		ctx:    ctx,
// 		svcCtx: svcCtx,
// 	}
// }

// func (l *CreateTokenLogic) CreateToken(req *types.TokenInfo) (resp *types.BaseMsgResp, err error) {
// 	data, err := l.svcCtx.CoreRpc.CreateToken(l.ctx,
// 		&core.TokenInfo{
// 			Status:    req.Status,
// 			Uuid:      req.Uuid,
// 			Token:     req.Token,
// 			Source:    req.Source,
// 			Username:  req.Username,
// 			ExpiredAt: req.ExpiredAt,
// 		})
// 	if err != nil {
// 		return nil, err
// 	}
// 	return &types.BaseMsgResp{Msg: l.svcCtx.Trans.Trans(l.ctx, data.Msg)}, nil
// }


module token

import veb
import log
import orm
import time
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Create Token | 创建Token
@['/create_token'; post]
fn (app &Token) create_token(mut ctx Context) veb.Result {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
	mut result := create_token_resp(req) or { return ctx.json(json_error(503, '${err}')) }

	return ctx.json(json_success('success', result))
}

fn create_token_resp(req json2.Any) !map[string]Any {
	log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

	mut db := db_mysql()
	defer { db.close() }

	token_id := req.as_map()['id'] or { '' }.str()

	tokens := schema.SysToken{
   	id: token_id
    status: req.as_map()['status'] or { 0 }.u8()
    username: req.as_map()['username'] or { '' }.str()
    source: req.as_map()['Source'] or { '' }.str()
    expired_at: req.as_map()['expiredAt'] or { time.now() }.to_time()!
    created_at: req.as_map()['createdAt'] or {time.now()}.to_time()! //时间传入必须是字符串格式{ "createdAt": "2025-04-18 17:02:38"}
    updated_at: req.as_map()['updatedAt'] or {time.now()}.to_time()!
	}
  mut sys_token := orm.new_query[schema.SysToken](db)
	sys_token.insert(tokens)!

  return map[string]Any{}
}
