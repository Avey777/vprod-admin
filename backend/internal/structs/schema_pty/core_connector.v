// CREATE TABLE connectors (
//     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
//     -- 连接器标识和类型
//     provider VARCHAR(50) NOT NULL,  -- 如: 'google', 'github', 'wechat'
//     connector_type VARCHAR(50) NOT NULL,  -- 如: 'social', 'enterprise', 'email'
//     -- 配置信息（JSON格式，存储客户端ID、密钥等）
//     config JSONB NOT NULL,
//     -- 元数据
//     display_name VARCHAR(255),
//     description TEXT,
//     logo_url TEXT,
//     -- 状态控制
//     is_enabled BOOLEAN DEFAULT TRUE,
//     is_development BOOLEAN DEFAULT FALSE,  -- 开发环境专用
//     -- 时间戳
//     created_at TIMESTAMPTZ DEFAULT NOW(),
//     updated_at TIMESTAMPTZ DEFAULT NOW(),
//     -- 约束和索引
//     UNIQUE(provider, connector_type),
//     INDEX idx_connectors_provider (provider),
//     INDEX idx_connectors_type (connector_type)
// );

// Email and SMS connectors
// Social connectors

//     Github
//     Google
//     QQ
//     WeChat
//     Facebook
//     DingTalk
//     Weibo
//     Gitee
//     LinkedIn
//     Wecom
//     Lark
//     Gitlab
//     Apple
//     AzureAD
//     Slack
