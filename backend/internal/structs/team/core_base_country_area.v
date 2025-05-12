module team

import time

@[table: 'ed_base_country_area']
pub struct EdBaseCountryArea {
pub:
	id                   string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	sys_name             string  @[required; sql: 'sys_name'; sql_type: 'VARCHAR(255)'; zcomments: 'Name local | 地区&国家简称（系统实际使用字段）']
	sys_country_code     string  @[required; sql: 'sys_country_code'; sql_type: 'VARCHAR(255)'; zcomments: 'System country code | 系统内部使用的国家代码（系统字段）']
	name_local           string  @[required; sql: 'name_local'; sql_type: 'VARCHAR(255)'; zcomments: 'Name local | 地区&国家本地语简称']
	langcode_local       string  @[required; sql: 'langcode_local'; sql_type: 'VARCHAR(255)'; zcomments: 'Local language code | 本地语代码']
	govt_code            ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Government code | 各国家本土标准代码(如GB/T 2260-2020)']
	gid_zero             ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'GID_0 | GADM数据库中的字段，用于标识国家']
	hasc                 ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Hierarchical Administrative Subdivision Codes (HASC_0)']
	iso_two              ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Alpha-2 code(ISO 3166-2) | 两字母代码']
	iso_three            ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Alpha-3 code(ISO 3166-3) | 三字母代码']
	numeric              ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'ISO 3166-1 numeric | 数字代码']
	international_prefix ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'International dialing prefix | 国际冠码']
	phone_area_code      ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'International phone area code | 国际电话区号']
	postal_code          ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'International postal code | 国际邮编']
	domain_name          ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'International domain names (IDN) | 国际域名']
	continent_code       ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Big week code | 所属大州字母代码']
	coord_bounds         ?string @[sql_type: 'LONGTEXT'; zcomments: 'Geographical Coordinate Boundaries | 地理坐标边界']
	sort                 ?int    @[sql_type: 'INT UNSIGNED'; zcomments: 'Sort Number | 排序编号']
	status               u8      @[default: 0; sql_type: 'TINYINT UNSIGNED'; zcomments: 'Status  0: normal 1: ban | 状态']
	name_en              ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'English short name(ISO) | 地区&国家简称(英文)']
	name_zh              ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'zh_CN short name(ISO) | 地区&国家简称(中文)']

	updater_id ?string    @[sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; sql_type: 'TINYINT UNSIGNED'; zcomments: '逻辑删除，0：未删除，1：已删除']
	deleted_at ?time.Time @[sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
