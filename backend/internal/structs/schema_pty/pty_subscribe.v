/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

import time

@[comment: '订阅表']
@[table: 'pty_subscribe']
pub struct PtySubscribe {
pub:
	id           u64       @[auto_increment; comment: '主键ID'; primary; sql_type: 'BIGINT']
	uuid         string    @[comment: 'uuid'; required; sql_type: 'VARCHAR(36)'; unique: 'uuid']
	name         string    @[comment: '名称'; required; sql_type: 'VARCHAR(36)']
	service      string    @[comment: '服务id'; required; sql_type: 'VARCHAR(36)'; unique: 'unique_subscribe']
	application  string    @[comment: '应用id,项目id,系统id'; required; sql_type: 'VARCHAR(36)'; unique: 'unique_subscribe']
	apply_status bool      @[comment: '申请状态'; index: 'status'; required; sql_type: 'TINYINT(1)']
	applier      string    @[comment: '申请人'; index: 'applier'; required; sql_type: 'VARCHAR(36)']
	from         bool      @[comment: '来源'; index: 'status'; required; sql_type: 'TINYINT(1)']
	create_at    time.Time @[comment: '创建时间'; default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']
	approve_at   time.Time @[comment: '审核时间'; default: 'CURRENT_TIMESTAMP'; sql_type: 'TIMESTAMP']
}
