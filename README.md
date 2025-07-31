## 简介
vprod 是一个后台管理系统，基于 veb构建适用于快速搭建后台管理系统。

-------------
## 项目结构
```text
v-admin
  backend                          # 单个服务目录，一般是某微服务名称
  ├── etc                                 # 静态配置文件目录
  │   └── example.yaml
  ├── main.v                              # 程序启动入口文件
  └── internal                            # 单个服务内部文件，其可见范围仅限当前服务
      ├── config                          # 静态配置文件对应的结构体声明目录以及配置代码
      │   └── check.v
      ├── handler                         # 可选，一般http服务会有这一层做路由管理，handler为固定后缀
      │   ├── app_start.v
      │   ├── app_struct.v
      │   ├── routes_sys_admin.v
      │   └── routes.v
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
      ├── structs                         # 结构体存放目录
      │   └── xxx_structs.v
      └── svc                             # (service context)依赖注入目录，logic的依赖都要在这里进行显式注入
          └── service_context.v
```

-------------
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
- [ ] 权限: 内置动态路由权限生成方案, 集成RBAC权限控制
-------------
## 特性

- web框架：使用v标准库的 veb
- ORM：使用v标准库的 orm
- Database Connection Pool：数据库线程池，支持mysql和pgsql

-------------
## 租户权限
流程图绘制[Mermaid Live Editor](https://www.mermaidchart.com/play?utm_source=mermaid_live_editor&utm_medium=toggle#pako:eNqVkEFLwzAcxb9KyGHMQ5Gk3QalFjvEs8hu1kPWZm5Qk5J0DBm7iifBgyhevAqC3vTix3GK38JkTeo21oG55b33f_9fMoUJTyn04SDjk2RIRAF6BzEDctw_EyQfAolOYhjInCituMjoXsIzLvxwQPwBcXIqJGfgiIuCZMABnx8P85v7n7unr6v3YFdPhTE8VX3mMNRWdWVqQvvO_PZy_nj9_fwa9EVYyhFLBR-lf5YpoCxd4cL_4dJlL2_buDqqrkxpLkNUCpZoRRxx6azDqdNtxjDKc4BiuAMcJ1T_BxoKtnSZ_kxtYzW3sA-VsAkZ6UADMFzj4wqfuSrSo-S86mTIU9Ixz-hyzDOr3SrW2rLb8qKmCo0lFQu1fFJkFlaQrk3jKo2rtHUjw-ZatuU17sLs2qtnsrrci5mV2_tTIIckpz4QfMxSms6s1VmyaFIYXeKNMkO1RTUDbk2Pt1n3avtbNUXrC-DsF_G8OEo)

```
flowchart TD
 subgraph s1["<span style=color:>fa:fa-person Portal - 会员门户</span>"]
        n16["会员web-商城端<br>会员Android-商城端"]
  end
 subgraph s2["<span style=color:>fa:fa-person Portal - 商家门户</span>"]
        n17["商家web-端<br>商家Android-端<br>商家ios-端"]
  end
    B("App 1") --> s1 & s2
    n1["App 2"] --> F["fa:fa-person Portal 1"] & n2["fa:fa-person Portal 2"]
    n3["Team2"] --> n14["Role 2"]
    n4["App 3"] --> n5["fa:fa-person Portal 1"]
    n11(["user 1"]) --> A["Team 1"] & n3
    n12(["user 2"]) --> n3
    A --> n13["Role 1"]
    n13 --> B
    n14 --> n1 & n4

    n16@{ shape: rounded}
    n17@{ shape: rect}
    s2@{ shape: rect}
    n1@{ shape: rounded}
    n2@{ shape: rect}
    n3@{ shape: rect}
    n14@{ shape: rect}
    n4@{ shape: rounded}
    n5@{ shape: rect}
    n13@{ shape: rect}
```

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
