module mcms

import time

// 站内私信消息分类表
@[table: 'mcms_site_inner_categories']
pub struct McmsSiteInnerCategory {
pub:
	id          string  @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	title       string  @[omitempty; required; sql: 'title'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Title | 分类名称']
	description ?string @[omitempty; sql: 'description'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Description | 分类描述']
	remark      ?string @[omitempty; sql: 'remark'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Remark | 备注信息']
	status      u8      @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint(1)'; zcomments: 'State true: normal false: ban | 状态 true 正常 false 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
