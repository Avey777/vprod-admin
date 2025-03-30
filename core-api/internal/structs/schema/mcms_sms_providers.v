module schema

import time

// 短信服务提供商表
@[table: 'mcms_sms_providers']
pub struct McmsSmsProvider {
pub:
	id         string @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name       string @[omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; unique: 'name'; zcomments: 'The SMS provider name | 短信服务的提供商']
	secret_id  string @[omitempty; required; sql: 'secret_id'; sql_type: 'VARCHAR(255)'; zcomments: 'The secret ID | 密钥 ID']
	secret_key string @[omitempty; required; sql: 'secret_key'; sql_type: 'VARCHAR(255)'; zcomments: 'The secret key | 密钥 Key']
	region     string @[omitempty; required; sql: 'region'; sql_type: 'VARCHAR(255)'; zcomments: 'The service region | 服务器所在地区']
	is_default u8     @[default: 0; omitempty; sql: 'is_default'; sql_type: 'tinyint(1)'; zcomments: 'Is it the default provider | 是否为默认提供商']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
