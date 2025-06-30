module schema_party

import time

@[comment: '用户-团队关联表（多对多）']
@[table: 'party_team_users']
pub struct PartyTeamUser {
pub:
	id      string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	user_id string @[comment: '用户ID'; omitempty; required; sql_type: 'CHAR(36)']
	team_id string @[comment: '团队ID'; omitempty; required; sql_type: 'CHAR(36)']
	role    u8     @[comment: '角色，0：成员，1：管理员，2：所有者'; default: 0; omitempty; sql_type: 'tinyint']

	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

/*
-- 用户-团队关联表（多对多）
CREATE TABLE user_teams (
    user_id INT NOT NULL,
    team_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, team_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE
);
*/
