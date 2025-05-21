module schema_tema

import time

@[table: 'subscribe_apply']
pub struct SubscribeApply {
pub:
	id          u64       @[auto_increment; primary; sql_type: 'BIGINT'; zcomments: '主键ID']
	uuid        string    @[required; sql_type: 'VARCHAR(36)'; unique: 'uuid'; zcomments: 'uuid']
	name        string    @[required; sql_type: 'VARCHAR(36)'; zcomments: '名称']
	service     string    @[index: 'service'; required; sql_type: 'VARCHAR(36)'; zcomments: '服务id']
	team        string    @[index: 'team'; required; sql_type: 'VARCHAR(36)'; zcomments: '团队id']
	application string    @[index: 'application'; required; sql_type: 'VARCHAR(36)'; zcomments: '应用id,项目id,系统id']
	apply_team  string    @[index: 'apply_team'; required; sql_type: 'VARCHAR(36)'; zcomments: '申请团队id']
	applier     string    @[index: 'applier'; required; sql_type: 'VARCHAR(36)'; zcomments: '申请人']
	apply_at    time.Time @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '申请时间']
	approver    string    @[index: 'approver'; required; sql_type: 'VARCHAR(36)'; zcomments: '审核人']
	approve_at  time.Time @[default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP'; zcomments: '审核时间']
	status      bool      @[index: 'status'; required; sql_type: 'TINYINT(1)'; zcomments: '审核状态']
	opinion     string    @[required; sql_type: 'TEXT'; zcomments: '审核意见']
	reason      string    @[required; sql_type: 'TEXT'; zcomments: '申请原因']
}
