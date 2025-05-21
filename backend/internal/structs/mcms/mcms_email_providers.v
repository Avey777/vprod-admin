module mcms

import time

// 邮件服务提供商表
@[table: 'mcms_email_providers']
pub struct McmsEmailProvider {
pub:
	id         string  @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name       string  @[omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; unique: 'name'; zcomments: 'The email provider name | 电子邮件服务的提供商']
	auth_type  u8      @[omitempty; required; sql: 'auth_type'; sql_type: 'tinyint unsigned'; zcomments: 'The auth type, supported plain, CRAMMD5 | 鉴权类型, 支持 plain, CRAMMD5']
	email_addr string  @[omitempty; required; sql: 'email_addr'; sql_type: 'VARCHAR(255)'; zcomments: 'The email address | 邮箱地址']
	password   ?string @[omitempty; sql: 'password'; sql_type: 'VARCHAR(255)'; zcomments: 'The email`s password | 电子邮件的密码']
	host_name  string  @[omitempty; required; sql: 'host_name'; sql_type: 'VARCHAR(255)'; zcomments: 'The host name is the email service`s host address | 电子邮箱服务的服务器地址']
	identify   ?string @[omitempty; sql: 'identify'; sql_type: 'VARCHAR(255)'; zcomments: 'The identify info, for CRAMMD5 | 身份信息, 支持 CRAMMD5']
	secret     ?string @[omitempty; sql: 'secret'; sql_type: 'VARCHAR(255)'; zcomments: 'The secret, for CRAMMD5 | 邮箱密钥, 用于 CRAMMD5']
	port       ?u32    @[omitempty; sql: 'port'; sql_type: 'int unsigned'; zcomments: 'The port of the host | 服务器端口']
	tls        u8      @[default: 0; omitempty; sql: 'tls'; sql_type: 'tinyint(1)'; zcomments: 'Whether to use TLS | 是否采用 tls 加密']
	is_default u8      @[default: 0; omitempty; sql: 'is_default'; sql_type: 'tinyint(1)'; zcomments: 'Is it the default provider | 是否为默认提供商']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
