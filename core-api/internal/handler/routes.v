module handler

import (
	"net/http"

	base "gitea.com/Tos/ed-driver/internal/handler/base"
	tasks "gitea.com/Tos/ed-driver/internal/handler/tasks"
	"gitea.com/Tos/ed-driver/internal/svc"

	"github.com/zeromicro/go-zero/rest"
)

fn RegisterHandlers(server *rest.Server, serverCtx *svc.ServiceContext) {
	server.AddRoutes(
		rest.WithMiddlewares(
			[]rest.Middleware{serverCtx.Authority},
			[]rest.Route{
				{
					Method:  http.MethodPost,
					Path:    "/driver/tasks/list",
					Handler: tasks.GetDriverTaskListHandler(serverCtx),
				},
			}...,
		),
		rest.WithJwt(serverCtx.Config.Auth.AccessSecret),
	)

	server.AddRoutes(
		[]rest.Route{
			{
				Method:  http.MethodGet,
				Path:    "/init/database",
				Handler: base.InitDatabaseHandler(serverCtx),
			},
		},
	)
}
