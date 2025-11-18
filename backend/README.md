DDD

```
┌─────────────────────────────────────┐
│          Handler                    │
│  - 接收请求 / 返回响应                 │
│  - 校验参数 / 鉴权                    │
│  - 调用 Application Service          │
│  - 不包含业务逻辑                      │
└───────────────┬─────────────────────┘
                │ 调用
                ▼
┌─────────────────────────────────────┐
│   Application Service               │
│  - 协调业务流程                       │
│  - 调用 Domain（核心业务逻辑）         │
│  - 处理事务 / 日志 / 异常              │
│  - 调用基础设施服务（MQ、外部 API）     │──────────┐
└───────────────┬─────────────────────┘          │
                │ 调用                            │
                ▼                                │
┌─────────────────────────────────────┐          │
│          Domain                     │          │
│  - 核心业务逻辑                       │          │
│    • 实体 / 值对象                    │         │
│    • 聚合根 / 聚合边界                 │         │
│    • 领域服务（复杂逻辑）               │         │
│  - 定义 Repository 接口               │         │
│  - 只依赖接口，不关心实现               │         │
│  - 完全专注业务规则                    │         │
└───────────────┬─────────────────────┘         │
                │ 实现依赖                        │
                ▼                               │
┌─────────────────────────────────────┐         │
│          Infra/Adapters             │◀────────┘
│  - 实现 Repository 接口              │
│  - 实际操作 DB / 缓存 / MQ            │
│  - 提供 Application/Domain 调用      │
│  - 对领域逻辑透明                     │
│  - 提供非业务相关服务（邮件、外部 API）  │
└─────────────────────────────────────┘

```

```
my_project/
├── main/                   # 程序入口模块
│   └── main.v              # 程序入口
├── routes/                 # HTTP/API 路由
│   ├── user_routes.v       # 注册路由
│   └── auth_routes.v
├── handlers/               # Handler / Controller 层
│   ├── user_handler.v      # 处理具体请求
│   └── auth_handler.v
├── structs/                # 全局模型 structs（数据库模型、共享结构体）
│   └── user_struct.v
├── domain/                 # 领域层
│   ├── user.v              # 领域模型
│   └── services/
│       └── create_user.v
├── application/            # 应用层
│   ├── dto/                # Data Transfer Object
│   │   └── user_dto.v
│   └── services/
│       └── create_user.v
├── adapters/               # Hexagonal 风格外部适配器
│   ├── redis/
│   │   └── redis.v
│   ├── mq/
│   │   └── mq.v
│   ├── repositories/
│   │   └── user_repo.v
│   └── dbpool/
│       └── mysql_pool.v
├── common/                 # 通用工具
│   ├── opt/
│   ├── utils/
│   ├── captcha/
│   ├── encrypt/
│   ├── jwt/
│   └── api/
├── config/                 # 全局配置
│   ├── conf.v
│   ├── app_config.v
│   └── db_config.v
└── i18n/                   # 国际化全局资源
    ├── en.v
    └── zh.v
```
