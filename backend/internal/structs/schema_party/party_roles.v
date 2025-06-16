module schema_party

import time

// 角色表
@[table: 'sys_roles']
pub struct SysRole {
pub:
	id              string  @[immutable; omitempty; primary; sql_type: 'CHAR(36)']
	name            string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Role name | 角色名']
	code            string  @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Role code for permission control in front end | 角色码，用于前端权限控制']
	default_router  string  @[default: '"/dashboard"'; omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Default menu : dashboard | 默认登录页面']
	remark          ?string @[omitempty; sql_type: 'VARCHAR(255)'; zcomment: 'Remark | 备注']
	sort            u32     @[default: 0; omitempty; sql_type: 'int'; zcomment: 'Order number | 排序编号']
	data_scope      u8      @[default: 1; omitempty; sql_type: 'tinyint'; zcomment: 'Data scope 1 - all data 2 - custom dept data 3 - own dept and sub dept data 4 - own dept data  5 - your own data | 数据权限范围 1 - 所有数据 2 - 自定义部门数据 3 - 您所在部门及下属部门数据 4 - 您所在部门数据 5 - 本人数据']
	custom_dept_ids ?string @[omitempty; sql_type: 'CHAR(36)'; zcomment: 'Custom department setting for data permission | 自定义部门数据权限']
	status          u8      @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']
  team_id     string    @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '所属团队ID']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
