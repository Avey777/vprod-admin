module schema

import time
// import rand

// 用户表
@[table: 'sys_users']
pub struct SysUser {
pub:
	id            string     @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID rand.uuid_v4()']
	username      string     @[omitempty; required; sql: 'username'; sql_type: 'VARCHAR(255)'; unique; zcomments: 'User`s login name | 登录名']
	password      string     @[omitempty; required; sql: 'password'; sql_type: 'VARCHAR(255)'; zcomments: 'Password | 密码']
	nickname      string     @[omitempty; sql_type: 'VARCHAR(255)'; unique; zcomments: 'Nickname | 昵称']
	description   ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomments: 'The description of user | 用户的描述信息']
	home_path     string     @[default: '\"/dashboard\"'; omitempty; sql_type: 'VARCHAR(255)'; zcomments: 'The home page that the user enters after logging in | 用户登陆后进入的首页']
	mobile        ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomments: 'Mobile number | 手机号']
	email         ?string    @[omitempty; sql_type: 'VARCHAR(255)'; zcomments: 'Email | 邮箱号']
	avatar        ?string    @[omitempty; sql_type: 'VARCHAR(512)'; zcomments: 'Avatar | 头像路径']
	department_id ?u64       @[omitempty; optional; sql_type: 'VARCHAR(255)'; zcomments: 'Department ID | 部门ID']
	status        u8         @[default: 0; omitempty; sql_type: 'tinyint'; zcomments: '状态，0：正常，1：禁用']
	updater_id    ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at    time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id    ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at    time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag      u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at    ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
