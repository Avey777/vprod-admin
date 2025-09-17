// CREATE TABLE user_connectors (
//     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
//     -- 外键关联
//     user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
//     connector_id UUID NOT NULL REFERENCES connectors(id) ON DELETE CASCADE,
//     -- 第三方身份标识
//     provider_user_id VARCHAR(255) NOT NULL,  -- 第三方系统中的用户ID
//     -- 身份信息（从第三方获取）
//     profile JSONB,  -- 存储用户资料快照（用户名、头像等）
//     -- OAuth令牌（需加密存储）
//     access_token TEXT,  -- 加密存储
//     refresh_token TEXT,  -- 加密存储
//     token_expires_at TIMESTAMPTZ,
//     -- 元数据
//     is_primary BOOLEAN DEFAULT FALSE,  -- 是否为主要登录方式
//     verified BOOLEAN DEFAULT TRUE,     -- 第三方身份是否已验证
//     -- 时间戳
//     created_at TIMESTAMPTZ DEFAULT NOW(),
//     updated_at TIMESTAMPTZ DEFAULT NOW(),
//     linked_at TIMESTAMPTZ DEFAULT NOW(),  -- 连接建立时间
//     last_used_at TIMESTAMPTZ,             -- 最后使用时间
//     -- 约束和索引
//     UNIQUE(connector_id, provider_user_id),  -- 确保第三方账户只连接一个系统用户
//     UNIQUE(user_id, connector_id),           -- 确保用户不会重复连接同一提供商
//     INDEX idx_user_connectors_user (user_id),
//     INDEX idx_user_connectors_connector (connector_id),
//     INDEX idx_user_connectors_provider_user (provider_user_id)
// );
