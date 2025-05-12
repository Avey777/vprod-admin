module team

import time

//团队表
@[table: 'team']
pub struct Team {
pub:
	id          u64       @[auto_increment; primary; sql_type: 'BIGINT'; zcomments: '主键ID']
	uuid        string    @[required; sql_type: 'VARCHAR(36)'; unique: 'uuid'; zcomments: 'UUID']
	name        string    @[required; sql_type: 'VARCHAR(100)'; zcomments: '团队名称']
	description string    @[required; sql_type: 'VARCHAR(255)'; zcomments: '团队描述']
	creator     string    @[required; sql_type: 'VARCHAR(36)'; zcomments: '创建人id']
	updater     string    @[required; sql_type: 'VARCHAR(36)'; zcomments: '修改人id']
	create_at   time.Time @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '创建时间']
	update_at   time.Time @[default: 'CURRENT_TIMESTAMP'; on_update: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '修改时间']
	is_delete   bool      @[required; sql_type: 'TINYINT(1)'; zcomments: '是否删除']
}
