module schema_tema

import time

@[table: 'ed_base_area']
pub struct EdBaseArea {
pub:
	id                  string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	parent_country_id   string  @[required; sql: 'parent_country_id'; sql_type: 'CHAR(36)'; zcomments: 'Country ID | 国家id']
	parent_adm_id       string  @[required; sql: 'parent_adm_id'; sql_type: 'CHAR(36)'; zcomments: 'Parent adm area ID | 父级行政id']
	sys_adm_name        string  @[required; sql: 'sys_adm_name'; sql_type: 'VARCHAR(255)'; zcomments: 'System name local | 行政地区简称（系统字段）']
	sys_adm_code        string  @[required; sql: 'sys_adm_code'; sql_type: 'VARCHAR(255)'; zcomments: 'System adm code | 行政代码(系统字段)']
	parent_sys_adm_code string  @[required; sql: 'parent_sys_adm_code'; sql_type: 'VARCHAR(255)'; zcomments: 'Parent administrative division code | 父级别行政编码(系统字段)']
	sys_country_code    string  @[required; sql: 'sys_country_code'; sql_type: 'VARCHAR(255)'; zcomments: 'System country code | 系统内部使用的国家代码（系统字段）']
	name_local          ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Name local | 行政地区本地语简称']
	govt_code           ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Government code | 各国家本土标准行政代码']
	gid_zero            ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'GID_0 | GADM数据库国家标识字段']
	hasc                ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'HASC编码(如北京：CN.BJ)']
	iso_two             ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Alpha-2 code(ISO 3166-2)']
	iso_three           ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'Alpha-3 code(ISO 3166-3)']
	numeric             ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'ISO 3166-1 numeric | 数字代码']
	postal_code         ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'zip/postal code | 邮政编码']
	level               u8      @[default: 1; sql_type: 'TINYINT'; zcomments: 'ADM level | 行政区域等级（1-5级）']
	tree_id             string  @[required; sql: 'tree_id'; sql_type: 'CHAR(36)'; zcomments: 'Tree adm ID | 树行政id']
	coord_bounds        ?string @[sql_type: 'LONGTEXT'; zcomments: 'Geographical Coordinate Boundaries | 地理坐标边界']
	sort                ?u64    @[sql_type: 'BIGINT UNSIGNED'; zcomments: 'Sort number | 排序编号']
	status              u8      @[default: 0; sql_type: 'TINYINT UNSIGNED'; zcomments: 'Status  0: normal 1: ban | 状态']
	adm_merger_name     ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'ADM merger name | 行政区合并名称[数组]（本地语）']
	adm_short_name      ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'ADM short name | 简称（本地语）']
	pinyin              ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'ADM pinyin | 拼音']
	first               string  @[default: '0'; sql_type: 'VARCHAR(50)'; zcomments: '首字母']
	name_en             ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'English short name(ISO) | 英文简称']
	name_zh             ?string @[sql_type: 'VARCHAR(255)'; zcomments: 'zh_CN short name(ISO) | 中文简称']

	updater_id ?string    @[sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; sql_type: 'TINYINT UNSIGNED'; zcomments: '逻辑删除，0：未删除，1：已删除']
	deleted_at ?time.Time @[sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
