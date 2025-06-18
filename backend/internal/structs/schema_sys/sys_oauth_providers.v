module schema_sys

import time

@[table: 'sys_oauth_providers']
@[comment: 'Oauth提供商表']
pub struct SysOauthProvider {
pub:
	id            string @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomment: 'UUID']
	name          string @[omitempty; sql_type: 'VARCHAR(64)'; zcomment: 'The provider`s name | 提供商名称']
	client_id     string @[omitempty; sql_type: 'CHAR(64)'; zcomment: 'The client id | 客户端 id']
	client_secret string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The client secret | 客户端密钥']
	redirect_url  string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The redirect url | 跳转地址']
	scopes        string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The scopes | 权限范围']
	auth_url      string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The auth url of the provider | 认证地址']
	token_url     string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The token url of the provider | 获取 token地址']
	auth_style    u64    @[omitempty; sql_type: 'int(64)'; zcomment: 'The auth style, 0: auto detect 1: third party log in 2: log in with username and password | 鉴权方式 0 自动 1 第三方登录 2 使用用户名密码']
	info_url      string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'The URL to request user information by token | 用户信息请求地址']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
