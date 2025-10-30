## 简介

v-admin 是一个后台管理系统，基于 veb构建适用于快速搭建后台管理系统。

---

## 项目结构

```text
v-admin
  backend                          # 单个服务目录，一般是某微服务名称
  ├── etc                                 # 静态配置文件目录
  │   └── example.yaml
  ├── app_start.v                         # veb 服务
  ├── main.v                              # 程序启动入口文件
  └── internal                            # 所有服务内部文件
      ├── config                          # 静态配置文件对应的结构体声明目录以及配置代码
      │   └── check.v
      ├── handler                         # 可选，一般http服务会有这一层做外部请求处理，handler为固定后缀
      │   └── app_struct.v
      ├── i18n                            # 国际化(本地化)目录
      │   ├── locale
      │   │   ├── zh.json
      │   │   └── en.json
      │   └── vars.v
      ├── logic                           # 业务目录，所有业务编码文件都存放在这个目录下面，logic为固定后缀
      │   ├── sys_api/
      │   ├── pay_api/
      │   └── mcms_api/
      ├── middleware                      # 中间件目录，所有中间件文件都存放在这个目录下面，middleware为固定后缀
      │   ├── auth_middleware.v
      │   ├── logging_middleware.v
      │   └── xxx_middleware.v
      ├── routes                         # http服务做路由管理，routes为固定后缀
      │   ├── app_struct.v
      │   ├── routes_sys_admin.v
      │   └── routes.v
      ├── structs                         # 结构体存放目录
      │   └── xxx_structs.v
      └── svc                             # (service context)依赖注入目录，logic的依赖都要在这里进行显式注入
          └── service_context.v
```

---

## TODO

- [x] HTTP1 (HTTP2 and HTTP3 future)
- [x] Logging Middleware
- [x] Autherity Middleware(JWT)
- [x] Cores Middleware
- [ ] Data permission middleware
- [x] Config Middleware
- [x] Database connections pool Middleware
- [ ] i18n
- [ ] Multitenancy (tenant resolution) [多租户、多团队、多应用]
- [ ] Support OpenAPI, generate OpenAPI data automatic (go-swagger)
- [x] Permission: RBAC permission control

---

## 特性

- web框架：使用v标准库的 veb
- ORM：使用v标准库的 orm
- Database Connection Pool：数据库线程池，支持mysql和pgsql

---

## 缓存路线

- 缓存技术路线：[readyset](https://github.com/readysettech/readyset)
- 缓存表：使用readyset缓存热点表
- 性能：略低于redis

  Tips: 百万级用户, 并发 5000- QPS, readyset完全可以支撑. 若用户量超过百万级, 高并发5000+ QPS, 相信也已经有足够资金去扩展系统了.

---

## 租户权限

关系图:[Mermaid Live Editor](https://www.mermaidchart.com/play?utm_source=mermaid_live_editor&utm_medium=toggle#pako:eNqVkEFLwzAcxb9KyGHMQ5Gk3QalFjvEs8hu1kPWZm5Qk5J0DBm7iifBgyhevAqC3vTix3GK38JkTeo21oG55b33f_9fMoUJTyn04SDjk2RIRAF6BzEDctw_EyQfAolOYhjInCituMjoXsIzLvxwQPwBcXIqJGfgiIuCZMABnx8P85v7n7unr6v3YFdPhTE8VX3mMNRWdWVqQvvO_PZy_nj9_fwa9EVYyhFLBR-lf5YpoCxd4cL_4dJlL2_buDqqrkxpLkNUCpZoRRxx6azDqdNtxjDKc4BiuAMcJ1T_BxoKtnSZ_kxtYzW3sA-VsAkZ6UADMFzj4wqfuSrSo-S86mTIU9Ixz-hyzDOr3SrW2rLb8qKmCo0lFQu1fFJkFlaQrk3jKo2rtHUjw-ZatuU17sLs2qtnsrrci5mV2_tTIIckpz4QfMxSms6s1VmyaFIYXeKNMkO1RTUDbk2Pt1n3avtbNUXrC-DsF_G8OEo)

---

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
