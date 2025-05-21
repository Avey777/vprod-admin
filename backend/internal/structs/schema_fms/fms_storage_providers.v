module schema_fms

import time

// 文件存储服务提供商表
@[table: 'fms_storage_providers']
pub struct FmsStorageProvider {
pub:
	id         string  @[primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name       string  @[omitempty; required; sql: 'name'; sql_type: 'VARCHAR(255)'; unique: 'name'; zcomments: 'The cloud storage service name | 服务名称']
	bucket     string  @[omitempty; required; sql: 'bucket'; sql_type: 'VARCHAR(255)'; zcomments: 'The cloud storage bucket name | 云存储服务的存储桶']
	secret_id  string  @[omitempty; required; sql: 'secret_id'; sql_type: 'VARCHAR(255)'; zcomments: 'The secret ID | 密钥 ID']
	secret_key string  @[omitempty; required; sql: 'secret_key'; sql_type: 'VARCHAR(255)'; zcomments: 'The secret key | 密钥 Key']
	endpoint   string  @[omitempty; required; sql: 'endpoint'; sql_type: 'VARCHAR(255)'; zcomments: 'The service URL | 服务器地址']
	folder     ?string @[omitempty; sql: 'folder'; sql_type: 'VARCHAR(255)'; zcomments: 'The folder in cloud | 云服务目标文件夹']
	region     string  @[omitempty; required; sql: 'region'; sql_type: 'VARCHAR(255)'; zcomments: 'The service region | 服务器所在地区']
	is_default u8      @[default: 0; omitempty; sql: 'is_default'; sql_type: 'tinyint(1)'; zcomments: 'Is it the default provider | 是否为默认提供商']
	use_cdn    u8      @[default: 0; omitempty; sql: 'use_cdn'; sql_type: 'tinyint(1)'; zcomments: 'Does it use CDN | 是否使用 CDN']
	cdn_url    ?string @[omitempty; sql: 'cdn_url'; sql_type: 'VARCHAR(255)'; zcomments: 'CDN URL | CDN 地址']
	status     u8      @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint(1)'; zcomments: 'State true: normal false: ban | 状态 true 正常 false 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
