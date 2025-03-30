// CREATE TABLE `site_msg_inner_msg_categories` (
//   `id` bigint unsigned NOT NULL AUTO_INCREMENT,
//   `created_at` timestamp NOT NULL COMMENT 'Create Time | 创建日期',
//   `updated_at` timestamp NOT NULL COMMENT 'Update Time | 修改日期',
//   `state` tinyint(1) DEFAULT '1' COMMENT 'State true: normal false: ban | 状态 true 正常 false 禁用',
//   `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Category Title | 分类名称',
//   `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Category Description | 分类描述',
//   `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Category Remark | 备注信息',
//   PRIMARY KEY (`id`)
// ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

module schema

import time

// 站内私信消息分类表
@[table: 'site_msg_inner_msg_categories']
pub struct SiteMsgInnerMsgCategory {
pub:
	id          string  @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	state       u8      @[default: 1; omitempty; sql: 'state'; sql_type: 'tinyint(1)'; zcomments: 'State true: normal false: ban | 状态 true 正常 false 禁用']
	title       string  @[omitempty; required; sql: 'title'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Title | 分类名称']
	description ?string @[omitempty; sql: 'description'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Description | 分类描述']
	remark      ?string @[omitempty; sql: 'remark'; sql_type: 'VARCHAR(255)'; zcomments: 'Category Remark | 备注信息']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
