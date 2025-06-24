module schema_party

// import time

// 门户表 (独立实体)
@[comment: '门户表']
@[table: 'portals']
pub struct Portal {
pub:
	id                string @[auto; comment: '门户ID'; primary; sql_type: 'CHAR(20)']
	application_owner string @[comment: '应用所有者'; foreign: 'applications.owner'; required]
	application_name  string @[comment: '应用名称'; foreign: 'applications.name'; required]
	type              string @[comment: '门户类型(admin/merchant/member/supplier)'; index; required]
	name              string @[comment: '门户名称'; required; sql_type: 'VARCHAR(100)']
	base_url          string @[comment: '门户基础URL'; required; sql_type: 'VARCHAR(255)']
	description       string @[comment: '门户描述'; omitempty; sql_type: 'VARCHAR(500)']

	// 状态管理
	is_active        bool   @[comment: '是否启用'; default: true]
	status           string @[comment: '门户状态(active/maintenance/disabled)'; default: 'active'; sql_type: 'VARCHAR(20)']
	last_active_time string @[comment: '最后活跃时间'; omitempty; sql_type: 'DATETIME']

	// 认证配置
	auth_method string @[comment: '认证方式(password/oauth2/sms)'; default: 'password'; sql_type: 'VARCHAR(20)']
	auth_config string @[comment: '认证配置(JSON)'; default: '{}'; sql_type: 'JSON']

	// 业务属性
	access_level string @[comment: '访问级别(public/internal/private)'; default: 'public'; sql_type: 'VARCHAR(20)']
	features     string @[comment: '支持的功能(JSON数组)'; default: '[]'; sql_type: 'JSON']
	theme        string @[comment: '主题配置(JSON)'; default: '{}'; sql_type: 'JSON']

	// 模板内容
	html_template string @[comment: 'HTML模板'; omitempty; sql_type: 'MEDIUMTEXT']

	// OAuth配置
	client_id     string @[comment: '客户端ID'; required; sql_type: 'VARCHAR(100)']
	client_secret string @[comment: '客户端密钥'; required; sql_type: 'VARCHAR(100)']
	redirect_uris string @[comment: '重定向URI(JSON数组)'; default: '[]'; sql_type: 'JSON']
	scope         string @[comment: '授权范围'; default: 'read'; sql_type: 'VARCHAR(100)']
	auth_url      string @[comment: '认证URL'; omitempty; sql_type: 'VARCHAR(255)']
	token_url     string @[comment: '令牌URL'; omitempty; sql_type: 'VARCHAR(255)']

	// 令牌配置
	token_format            string @[comment: '令牌格式'; omitempty; sql_type: 'VARCHAR(50)']
	expire_in_hours         int    @[comment: '令牌过期时间(小时)'; default: 24]
	refresh_expire_in_hours int    @[comment: '刷新令牌过期时间(小时)'; default: 720]
}
