// package token

// import (
// 	"context"

// 	"github.com/suyuan32/simple-admin-core/api/internal/svc"
// 	"github.com/suyuan32/simple-admin-core/api/internal/types"
// 	"github.com/suyuan32/simple-admin-core/rpc/types/core"

// 	"github.com/zeromicro/go-zero/core/logx"
// )

// type UpdateTokenLogic struct {
// 	logx.Logger
// 	ctx    context.Context
// 	svcCtx *svc.ServiceContext
// }

// func NewUpdateTokenLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UpdateTokenLogic {
// 	return &UpdateTokenLogic{
// 		Logger: logx.WithContext(ctx),
// 		ctx:    ctx,
// 		svcCtx: svcCtx,
// 	}
// }

// func (l *UpdateTokenLogic) UpdateToken(req *types.TokenInfo) (resp *types.BaseMsgResp, err error) {
// 	data, err := l.svcCtx.CoreRpc.UpdateToken(l.ctx, &core.TokenInfo{Id: req.Id, Source: req.Source, Status: req.Status})

// 	if err != nil {
// 		return nil, err
// 	}

// 	return &types.BaseMsgResp{Msg: l.svcCtx.Trans.Trans(l.ctx, data.Msg)}, nil
// }


module token

import veb
import log
import orm
import x.json2
import internal.config { db_mysql }
import internal.structs.schema
import internal.structs { Context, json_error, json_success }

// Update User Profile ||更新用户资料
@['/update_user_profile'; post]
fn (app &Token) update_token(mut ctx Context) veb.Result {
log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

req := json2.raw_decode(ctx.req.data) or { return ctx.json(json_error(502, '${err}')) }
mut result := update_token_resp(req) or { return ctx.json(json_error(503, '${err}')) }

return ctx.json(json_success('success', result))
}

fn update_token_resp(req json2.Any) !map[string]Any {
log.debug('${@METHOD}  ${@MOD}.${@FILE_LINE}')

user_id := req.as_map()['userId'] or { '' }.str()
avatar:= req.as_map()['avatar'] or { '' }.str()
email:= req.as_map()['email'] or { '' }.str()
mobile:= req.as_map()['mobile'] or { '' }.str()
nickname:= req.as_map()['nickname'] or { '' }.str()

mut db := db_mysql()
defer { db.close() }

mut sys_token := orm.new_query[schema.SysToken](db)
sys_token.set('avatar = ?', avatar)!
.set('email = ?', email)!
.set('mobile = ?', mobile)!
.set('nickname = ?', nickname)!
.where('id = ?', user_id)!
.update()!

return  map[string]Any{}
}
