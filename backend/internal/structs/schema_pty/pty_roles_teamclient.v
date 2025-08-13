/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

import time

@[commnet: '角色-门户授权表（多对多）']
@[table: 'pty_role_teamclient']
pub struct PtyRoleTeamClient {
pub:
	id               string @[comment: '关系ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	role_id          string @[comment: '角色ID'; omitempty; required; sql_type: 'CHAR(36)']
	portal_id        string @[comment: '门户ID'; omitempty; required; sql_type: 'CHAR(36)']
	permission_level string @[comment: '额外权限配置'; omitempty; sql_type: 'TEXT']

	// granted_at
	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

/*
-- 角色-门户授权表（多对多）
CREATE TABLE role_portals (
    role_id INT NOT NULL,
    portal_id INT NOT NULL,
    permission_level ENUM('read', 'write', 'admin') DEFAULT 'read',
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, portal_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (portal_id) REFERENCES portals(id) ON DELETE CASCADE
);
*/
