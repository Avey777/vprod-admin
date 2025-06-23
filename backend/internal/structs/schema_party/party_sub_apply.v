module schema_party

import time

@[comment: '订阅申请表']
@[table: 'subscribe_apply']
pub struct SubscribeApply {
pub:
	id          u64       @[auto_increment; comment: '主键ID'; primary; sql_type: 'BIGINT']
	uuid        string    @[comment: 'uuid'; required; sql_type: 'VARCHAR(36)'; unique: 'uuid']
	name        string    @[comment: '名称'; required; sql_type: 'VARCHAR(36)']
	service     string    @[comment: '服务id'; index: 'service'; required; sql_type: 'VARCHAR(36)']
	team        string    @[comment: '团队id'; index: 'team'; required; sql_type: 'VARCHAR(36)']
	application string    @[comment: '应用id,项目id,系统id'; index: 'application'; required; sql_type: 'VARCHAR(36)']
	apply_team  string    @[comment: '申请团队id'; index: 'apply_team'; required; sql_type: 'VARCHAR(36)']
	applier     string    @[comment: '申请人'; index: 'applier'; required; sql_type: 'VARCHAR(36)']
	apply_at    time.Time @[comment: '申请时间'; default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']
	approver    string    @[comment: '审核人'; index: 'approver'; required; sql_type: 'VARCHAR(36)']
	approve_at  time.Time @[comment: '审核时间'; default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']
	status      bool      @[comment: '审核状态'; index: 'status'; required; sql_type: 'TINYINT(1)']
	opinion     string    @[comment: '审核意见'; required; sql_type: 'TEXT']
	reason      string    @[comment: '申请原因'; required; sql_type: 'TEXT']
}
