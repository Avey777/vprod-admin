/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

import time

@[table: 'pty_teams']
@[commnet: '团队表']
pub struct PtyTeam {
pub:
	id          string  @[comment: '团队ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name        string  @[comment: '团队名称'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name']
	description ?string @[comment: '团队描述'; omitempty; sql_type: 'VARCHAR(512)']
	logo        ?string @[comment: '团队Logo'; omitempty; sql_type: 'VARCHAR(512)']
	status      u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

/*
-- 团队表
CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/
