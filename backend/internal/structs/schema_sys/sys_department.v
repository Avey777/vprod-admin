module schema_sys

import time

@[table: 'sys_departments']
@[comment: '部门表']
pub struct SysDepartment {
pub:
	id               string     @[comment: 'UUID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name             string     @[sql_type: 'VARCHAR(255)'; zcomment: 'Department name | 部门名称']
	ancestors        string     @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Parents IDs | 父级列表']
	leader           ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Department leader | 部门负责人']
	phone            ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Leader`s phone number | 负责人电话']
	email            ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Leader`s email | 部门负责人电子邮箱']
	remark           ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Remark | 备注']
	parent_id        string     @[omitempty; sql_type: 'CHAR(36)'; zcomment: 'Parent department ID | 父级部门ID']
	org_type         u32        @[default: 0; sql_type: 'int(32)'; zcomment: 'Department Type: 0->Regular | 组织类型: 0->普通机构']
	country          ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'country | 国家']
	province_state   ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Province/State | 省/州']
	city             ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'City | 市']
	district         ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'District | 区']
	detail_address   ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Detail Address | 详细地址']
	longitude        ?f32       @[omitempty; sql_type: 'double(11,8)'; zcomment: 'Longitude coordinates | WGS84经度']
	latitude         ?f32       @[omitempty; sql_type: 'double(10,8)'; zcomment: 'Latitude coordinates | WGS84纬度']
	service_boundary ?string    @[omitempty; sql_type: 'TEXT'; zcomment: 'service_boundary/Electronic Fence coordinates | 服务边界/电子围栏坐标 (仅存储，不计算)'] // POLOGY 类型不兼容 TiDB
	sort             u32        @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Sort Number | 排序编号']
	status           u8         @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
	updater_id       ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at       time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id       ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at       time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag         u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at       ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}
