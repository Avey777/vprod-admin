/*
暂时未使用
svc SeriveContext  服务上下文容器：聚合服务运行所需的所有核心依赖
*/
module svc

// "github.com/mojocn/base64Captcha"
// "github.com/redis/go-redis/v9"
// "github.com/suyuan32/simple-admin-common/i18n"
// "github.com/suyuan32/simple-admin-common/utils/captcha"
// "github.com/suyuan32/simple-admin-job/jobclient"
// "github.com/suyuan32/simple-admin-message-center/mcmsclient"
// import internal.config
// i18n2 "github.com/suyuan32/simple-admin-core/api/internal/i18n"
// "github.com/suyuan32/simple-admin-core/api/internal/middleware"
// "github.com/suyuan32/simple-admin-core/rpc/coreclient"

// "github.com/casbin/casbin/v2"
// "github.com/zeromicro/go-zero/rest"
// "github.com/zeromicro/go-zero/zrpc"

// struct ServiceContext {
// 	config config.Config
// authority rest.Middleware
// dataperm  rest.Middleware
// redis     redis.UniversalClient
// casbin    *casbin.Enforcer
// trans     *i18n.Translator
// captcha   *base64Captcha.Captcha
// }

// fn new_service_context(c config.Config) &ServiceContext {
// rds := c.RedisConf.MustNewUniversalRedis()

// cbn := c.CasbinConf.MustNewCasbinWithOriginalRedisWatcher(c.DatabaseConf.Type, c.DatabaseConf.GetDSN(),
// 	c.RedisConf)

// trans := i18n.NewTranslator(c.I18nConf, i18n2.LocaleFS)

// coreClient := coreclient.NewCore(zrpc.NewClientIfEnable(c.CoreRpc))

// return &ServiceContext{
// 	config: c
// captcha:   captcha.MustNewOriginalRedisCaptcha(c.Captcha, rds),
// redis:     rds,
// casbin:    cbn,
// trans:     trans,
// authority: middleware.NewAuthorityMiddleware(cbn, rds).Handle,
// data_perm:  middleware.NewDataPermMiddleware(rds, coreClient, trans).Handle,
// 	}
// }
