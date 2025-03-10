```text
vprod-service
  vprod-core-api
  ├── desc
  ├── etc
  │   └── example.yaml
  ├── main.v
  └── internal
      ├── config
      │   └── config.v
      ├── handler
      │   ├── xxxhandler.v
      │   └── routes.v
      ├── i18n
      │   ├── locale
      │   │   ├── zh.json
      │   │   └── en.json
      │   └── vars.v
      ├── logic
      │   └── xxx_logic.v
      ├── middleware
      │   └── xxx_middleware.v
      └── structs
      │   └── xxx_structs.v
      ├── svc
          └── service_context.v


· vprod-workspace：项目根目录
· vprod-core-api：单个服务目录，一般是某微服务名称
· desc：(descript)服务描述文件目录
· etc：静态配置文件目录
· main.go：程序启动入口文件
· internal：单个服务内部文件，其可见范围仅限当前服务
· config：静态配置文件对应的结构体声明目录
· handler：可选，一般 http 服务会有这一层做路由管理，handler 为固定后缀
· i18n：国际化(本地化)目录
· logic：业务目录，所有业务编码文件都存放在这个目录下面，logic 为固定后缀
· middleware：中间件目录，所有中间件文件都存放在这个目录下面，middleware 为固定后缀
· svc：(service context)依赖注入目录，所有 logic 层需要用到的依赖都要在这里进行显式注入
· structs：结构体存放目录
````
