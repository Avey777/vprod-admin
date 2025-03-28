module schema

import time

// 部门表
@[table: 'sys_departments']
pub struct SysDepartment {
pub:
	id               string  @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	name             string  @[sql_type: 'VARCHAR(255)'; zcomment: 'Department name | 部门名称']
	ancestors        string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Parents IDs | 父级列表']
	leader           ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Department leader | 部门负责人']
	phone            ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Leader`s phone number | 负责人电话']
	email            ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Leader`s email | 部门负责人电子邮箱']
	remark           ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Remark | 备注']
	parent_id        string  @[default: 0; omitempty; sql_type: 'CHAR(36)'; zcomment: 'Parent department ID | 父级部门ID']
	org_type         u32     @[default: 0; sql_type: 'int(32)'; zcomment: 'Department Type: 0->Regular | 组织类型: 0->普通机构']
	country          ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'country | 国家']
	province_state   ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Province/State | 省/州']
	city             ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'City | 市']
	district         ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'District | 区']
	detail_address   ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Detail Address | 详细地址']
	longitude        ?f32    @[omitempty; sql_type: 'double(11,8)'; zcomment: 'Longitude | WGS84经度']
	latitude         ?f32    @[omitempty; sql_type: 'double(10,8)'; zcomment: 'Latitude | WGS84纬度']
	service_boundary ?string @[omitempty; sql_type: 'polygon'; zcomment: 'Electronic Fence | 服务边界/电子围栏 (仅存储，不计算)']
	sort             int     @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status           u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
