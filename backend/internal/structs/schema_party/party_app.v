module schema_party

import time

@[table: 'party_applications']
@[comment: '应用表']
pub struct PartyApplication {
pub:
	id          string  @[comment: '应用ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name        string  @[comment: '应用名称'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name']
	app_key     string  @[comment: '应用Key'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'app_key']
	app_secret  string  @[comment: '应用Secret'; omitempty; required; sql_type: 'VARCHAR(255)']
	description ?string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(512)']
	icon        ?string @[comment: '应用图标'; omitempty; sql_type: 'VARCHAR(512)']
	status      u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
	team_id     string  @[comment: '所属团队ID'; omitempty; required; sql_type: 'CHAR(36)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

@[table: 'applications']
@[comment: '应用表']
pub struct Application {
pub:
	owner                 string @[comment: '应用所有者'; primary; required; sql_type: 'VARCHAR(100)']
	name                  string @[comment: '应用名称'; primary; required; sql_type: 'VARCHAR(100)']
	created_time          string @[comment: '创建时间'; omitempty; sql_type: 'VARCHAR(100)']
	display_name          string @[comment: '显示名称'; omitempty; sql_type: 'VARCHAR(100)']
	logo                  string @[comment: '应用Logo'; omitempty; sql_type: 'VARCHAR(100)']
	homepage_url          string @[comment: '主页URL'; omitempty; sql_type: 'VARCHAR(100)']
	description           string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(100)']
	organization          string @[comment: '所属组织'; omitempty; sql_type: 'VARCHAR(100)']
	cert                  string @[comment: '证书'; omitempty; sql_type: 'VARCHAR(100)']
	enable_password       bool   @[comment: '是否启用密码登录'; default: false; omitempty]
	enable_sign_up        bool   @[comment: '是否启用注册'; default: false; omitempty]
	enable_signin_session bool   @[comment: '是否启用会话登录'; default: false; omitempty]
	enable_code_signin    bool   @[comment: '是否启用验证码登录'; default: false; omitempty]
	// providers               []ProviderItem @[comment: '认证提供商列表'; omitempty; sql_type: 'MEDIUMTEXT']
	// signup_items            []SignupItem   @[comment: '注册项列表'; omitempty; sql_type: 'VARCHAR(1000)']
	// organization_obj        Organization   @[comment: '组织对象'; omitempty; sql_type: '-']
	client_id               string   @[comment: '客户端ID'; omitempty; sql_type: 'VARCHAR(100)']
	client_secret           string   @[comment: '客户端密钥'; omitempty; sql_type: 'VARCHAR(100)']
	redirect_uris           []string @[comment: '重定向URI列表'; omitempty; sql_type: 'VARCHAR(1000)']
	token_format            string   @[comment: '令牌格式'; omitempty; sql_type: 'VARCHAR(100)']
	expire_in_hours         int      @[comment: '令牌过期时间(小时)'; default: 0; omitempty]
	refresh_expire_in_hours int      @[comment: '刷新令牌过期时间(小时)'; default: 0; omitempty]
	signup_url              string   @[comment: '注册URL'; omitempty; sql_type: 'VARCHAR(200)']
	signin_url              string   @[comment: '登录URL'; omitempty; sql_type: 'VARCHAR(200)']
	forget_url              string   @[comment: '忘记密码URL'; omitempty; sql_type: 'VARCHAR(200)']
	affiliation_url         string   @[comment: '关联URL'; omitempty; sql_type: 'VARCHAR(100)']
	terms_of_use            string   @[comment: '使用条款'; omitempty; sql_type: 'VARCHAR(100)']
	signup_html             string   @[comment: '注册HTML'; omitempty; sql_type: 'MEDIUMTEXT']
	signin_html             string   @[comment: '登录HTML'; omitempty; sql_type: 'MEDIUMTEXT']
}

// 应用表 (核心实体)
@[table: 'applications']
@[comment: '应用表']
pub struct Application0 {
pub:
	// 基础信息 (保持不变)
	owner        string @[comment: '应用所有者'; primary; required; sql_type: 'VARCHAR(100)']
	name         string @[comment: '应用名称'; primary; required; sql_type: 'VARCHAR(100)']
	created_time string @[comment: '创建时间'; omitempty; sql_type: 'DATETIME']
	display_name string @[comment: '显示名称'; omitempty; sql_type: 'VARCHAR(100)']
	logo         string @[comment: '应用Logo'; omitempty; sql_type: 'VARCHAR(255)']
	homepage_url string @[comment: '主页URL'; omitempty; sql_type: 'VARCHAR(255)']
	description  string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(500)']

	// 多租户支持
	is_multi_tenant     bool   @[comment: '是否支持多租户'; default: false; omitempty]
	tenant_id_field     string @[comment: '租户ID字段名'; omitempty; sql_type: 'VARCHAR(50)']
	default_tenant_name string @[comment: '默认租户名称'; omitempty; sql_type: 'VARCHAR(100)']

	// 状态管理
	status string @[comment: '应用状态(active/inactive)'; default: 'active'; sql_type: 'VARCHAR(20)']
}

/*
-- 应用表（不再直接关联团队）
CREATE TABLE applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE, -- 应用名全局唯一
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/
