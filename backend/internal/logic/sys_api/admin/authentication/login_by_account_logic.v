// package publicuser

// func (l *LoginLogic) Login(req *types.LoginReq) (resp *types.LoginResp, err error) {
// 	if l.svcCtx.Config.ProjectConf.LoginVerify != "captcha" && l.svcCtx.Config.ProjectConf.LoginVerify != "all" {
// 		return nil, errorx.NewCodeAbortedError("login.loginTypeForbidden")
// 	}

// 	if ok := l.svcCtx.Captcha.Verify(config.RedisCaptchaPrefix+req.CaptchaId, req.Captcha, true); ok {
// 		l.ctx = datapermctx.WithScopeContext(l.ctx, entenum.DataPermAllStr)

// 		user, err := l.svcCtx.CoreRpc.GetUserByUsername(l.ctx,
// 			&core.UsernameReq{
// 				Username: req.Username,
// 			})
// 		if err != nil {
// 			return nil, err
// 		}

// 		if user.Status != nil && *user.Status != uint32(common.StatusNormal) {
// 			return nil, errorx.NewCodeInvalidArgumentError("login.userBanned")
// 		}

// 		if !encrypt.BcryptCheck(req.Password, *user.Password) {
// 			return nil, errorx.NewCodeInvalidArgumentError("login.wrongUsernameOrPassword")
// 		}

// 		token, err := jwt.NewJwtToken(l.svcCtx.Config.Auth.AccessSecret, time.Now().Unix(),
// 			l.svcCtx.Config.Auth.AccessExpire, jwt.WithOption("userId", user.Id), jwt.WithOption("roleId",
// 				strings.Join(user.RoleCodes, ",")), jwt.WithOption("deptId", user.DepartmentId))
// 		if err != nil {
// 			return nil, err
// 		}

// 		// add token into database
// 		expiredAt := time.Now().Add(time.Second * time.Duration(l.svcCtx.Config.Auth.AccessExpire)).UnixMilli()
// 		_, err = l.svcCtx.CoreRpc.CreateToken(l.ctx, &core.TokenInfo{
// 			Uuid:      user.Id,
// 			Token:     pointy.GetPointer(token),
// 			Source:    pointy.GetPointer("core_user"),
// 			Status:    pointy.GetPointer(uint32(common.StatusNormal)),
// 			Username:  user.Username,
// 			ExpiredAt: pointy.GetPointer(expiredAt),
// 		})

// 		if err != nil {
// 			return nil, err
// 		}

// 		err = l.svcCtx.Redis.Del(l.ctx, config.RedisCaptchaPrefix+req.CaptchaId).Err()
// 		if err != nil {
// 			logx.Errorw("failed to delete captcha in redis", logx.Field("detail", err))
// 		}
// //
// 		resp = &types.LoginResp{
// 			BaseDataInfo: types.BaseDataInfo{Msg: l.svcCtx.Trans.Trans(l.ctx, "login.loginSuccessTitle")},
// 			Data: types.LoginInfo{
// 				UserId: *user.Id,
// 				Token:  token,
// 				Expire: uint64(expiredAt),
// 			},
// 		}
// 		return resp, nil
// 	} else {
// 		return nil, errorx.NewCodeInvalidArgumentError("login.wrongCaptcha")
// 	}
// }8
