//订阅申请表
module team

import time

@[table: 'subscribe']
pub struct Subscribe {
pub:
	id           u64       @[auto_increment; primary; sql_type: 'BIGINT'; zcomments: '主键ID']
	uuid         string    @[required; sql_type: 'VARCHAR(36)'; unique: 'uuid'; zcomments: 'uuid']
	name         string    @[required; sql_type: 'VARCHAR(36)'; zcomments: '名称']
	service      string    @[required; sql_type: 'VARCHAR(36)'; unique: 'unique_subscribe'; zcomments: '服务id']
	application  string    @[required; sql_type: 'VARCHAR(36)'; unique: 'unique_subscribe'; zcomments: '应用id,项目id,系统id']
	apply_status bool      @[index: 'status'; required; sql_type: 'TINYINT(1)'; zcomments: '申请状态']
	applier      string    @[index: 'applier'; required; sql_type: 'VARCHAR(36)'; zcomments: '申请人']
	from         bool      @[index: 'status'; required; sql_type: 'TINYINT(1)'; zcomments: '来源']
	create_at    time.Time @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '创建时间']
	approve_at   time.Time @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '审核时间']
}
