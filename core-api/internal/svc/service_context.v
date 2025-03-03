module svc

import 	c-core-api.internal.config
// import (
	// "express-delivery/edcores/edcoresclient"

	// "gitea.com/Tos/ed-driver/internal/config"
	// i18n2 "gitea.com/Tos/ed-driver/internal/i18n"
	// "gitea.com/Tos/ed-driver/internal/middleware"

	// "github.com/suyuan32/simple-admin-common/i18n"
	// "github.com/suyuan32/simple-admin-core/rpc/coreclient"

	// "github.com/casbin/casbin/v2"
	// "github.com/zeromicro/go-zero/rest"
	// "github.com/zeromicro/go-zero/zrpc"
// )

ServiceContext struct {
  Config     config.Config

	// Casbin     *casbin.Enforcer
	// Authority  rest.Middleware
	// Trans      *i18n.Translator
	// CoreRpc    coreclient.Core       //simple-adminRpc
	// EdcoresRpc edcoresclient.Edcores // EdRpc
}

// func NewServiceContext(c config.Config) *ServiceContext {

// 	rds := c.RedisConf.MustNewUniversalRedis()

// 	cbn := c.CasbinConf.MustNewCasbinWithOriginalRedisWatcher(c.CasbinDatabaseConf.Type, c.CasbinDatabaseConf.GetDSN(), c.RedisConf)

// 	trans := i18n.NewTranslator(c.I18nConf, i18n2.LocaleFS)

// 	return &ServiceContext{
// 		Config:     c,
// 		Authority:  middleware.NewAuthorityMiddleware(cbn, rds, trans).Handle,
// 		Trans:      trans,
// 		CoreRpc:    coreclient.NewCore(zrpc.NewClientIfEnable(c.CoreRpc)),          //simple-adminRpc
// 		EdcoresRpc: edcoresclient.NewEdcores(zrpc.NewClientIfEnable(c.EdcoresRpc)), // EdRpc
// 	}
// }
