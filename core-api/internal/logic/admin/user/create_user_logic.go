package user

import (
	"context"

	"github.com/zeromicro/go-zero/core/errorx"

	"github.com/suyuan32/simple-admin-core/api/internal/svc"
	"github.com/suyuan32/simple-admin-core/api/internal/types"
	"github.com/suyuan32/simple-admin-core/rpc/types/core"

	"github.com/zeromicro/go-zero/core/logx"
)

type CreateUserLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewCreateUserLogic(ctx context.Context, svcCtx *svc.ServiceContext) *CreateUserLogic {
	return &CreateUserLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *CreateUserLogic) CreateUser(req *types.UserInfo) (resp *types.BaseMsgResp, err error) {
	if req.Password == nil || *req.Password == "" {
		return nil, errorx.NewApiBadRequestError("password can not be empty")
	}

	data, err := l.svcCtx.CoreRpc.CreateUser(l.ctx,
		&core.UserInfo{
			Status:       req.Status,
			Username:     req.Username,
			Password:     req.Password,
			Nickname:     req.Nickname,
			Description:  req.Description,
			HomePath:     req.HomePath,
			RoleIds:      req.RoleIds,
			Mobile:       req.Mobile,
			Email:        req.Email,
			Avatar:       req.Avatar,
			DepartmentId: req.DepartmentId,
			PositionIds:  req.PositionIds,
		})
	if err != nil {
		return nil, err
	}
	return &types.BaseMsgResp{Msg: l.svcCtx.Trans.Trans(l.ctx, data.Msg)}, nil
}



// 注册请求参数
// swagger:model RegisterReq
pub struct RegisterReq {
pub:
	// 用户名 | User Name
	// 必填 | required: true
	// 最大长度: 20 | max length: 20
	username string @[json: 'username'; validate: 'required,alphanum,max=20']

	// 密码 | Password
	// 必填 | required: true
	// 最小长度: 6 | min length: 6
	// 最大长度: 30 | max length: 30
	password string @[json: 'password'; validate: 'required,max=30,min=6']

	// 验证码ID | Captcha ID
	// 必填 | required: true
	// 固定长度: 20 | length: 20
	captcha_id string @[json: 'captchaId'; validate: 'required,len=20']

	// 验证码 | Captcha
	// 必填 | required: true
	// 固定长度: 5 | length: 5
	captcha string @[json: 'captcha'; validate: 'required,len=5']

	// 邮箱地址 | Email address
	// 必填 | required: true
	// 最大长度: 100 | max length: 100
	email string @[json: 'email'; validate: 'required,email,max=100']
}
