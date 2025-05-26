## 简介
vprod 是一个后台管理系统，基于 veb构建适用于快速搭建后台管理系统。

-------------
## 项目结构
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
· config：静态配置文件对应的结构体声明目录以及配置代码
· handler：可选，一般 http 服务会有这一层做路由管理，handler 为固定后缀
· i18n：国际化(本地化)目录
· logic：业务目录，所有业务编码文件都存放在这个目录下面，logic 为固定后缀
· middleware：中间件目录，所有中间件文件都存放在这个目录下面，middleware 为固定后缀
· svc：(service context)依赖注入目录，所有 logic 层需要用到的依赖都要在这里进行显式注入
· structs：结构体存放目录
````

-------------
## TODO
- [x] HTTP1 (HTTP2 and HTTP3 future)
- [x] Logging Middleware
- [x] Autherity Middleware(JWT)
- [x] Cores Middleware
- [ ] Data permission middleware
- [ ] Database connections pool
- [ ] i18n
- [ ] Multitenancy (tenant resolution) [多租户、多团队、多应用]
- [ ] Support OpenAPI, generate OpenAPI data automatic (go-swagger)
- [ ] 权限: 内置动态路由权限生成方案, 集成RBAC权限控制
-------------
## 特性

- web框架：使用v标准库的 veb
- ORM：使用v标准库的 orm
- Database Connection Pool：数据库线程池，支持mysql和pgsql

-------------
## Git 贡献提交规范

- 参考 [vue](https://github.com/vuejs/vue/blob/dev/.github/COMMIT_CONVENTION.md) 规范 ([Angular](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular))

    - feat 增加新功能
    - fix 修复问题/BUG
    - style 代码风格相关无影响运行结果的
    - perf 优化/性能提升
    - refactor 重构
    - revert 撤销修改
    - test 测试相关
    - docs 文档/注释
    - chore 依赖更新/脚手架配置修改等
    - workflow 工作流改进
    - ci 持续集成
    - types 类型定义文件更改
    - wip 开发中
