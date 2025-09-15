module schema_core

import time

@[table: 'core_connectors']
@[comment: '连接器表']
pub struct CoreConnector {
pub:
	id          string @[comment: '连接器ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name        string @[comment: '连接器名称'; primary; required; sql_type: 'VARCHAR(100)']
	logo        string @[comment: '连接器Logo'; omitempty; sql_type: 'VARCHAR(255)']
	type        string @[comment: '类型: Email and SMS, Social'; primary; required; sql_type: 'VARCHAR(100)']
	description string @[comment: '连接器描述'; omitempty; sql_type: 'VARCHAR(500)']
	status      u8     @[comment: '连接器状态, 0:active, 1:inactive'; default: 0; sql_type: 'VARCHAR(20)']

	updater_id ?string    @[comment: 'sys 修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: 'sys 创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

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
