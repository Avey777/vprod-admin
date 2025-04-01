module team

import time

@[table: 'team_member']
pub struct TeamMember {
pub:
	id        u64       @[auto_increment; primary; sql_type: 'BIGINT'; zcomments: '主键ID']
	come      string    @[index: 'department'; required; sql_type: 'VARCHAR(36)'; unique: 'department_uid'; zcomments: '归属id']
	uid       string    @[index: 'uid'; required; sql_type: 'VARCHAR(36)'; unique: 'department_uid'; zcomments: '用户id']
	create_at time.Time @[required; sql_type: 'TIMESTAMP'; zcomments: '创建时间']
}
