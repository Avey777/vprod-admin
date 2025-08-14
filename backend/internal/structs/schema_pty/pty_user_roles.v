/* party(pty): 客户、供应商、合作伙伴 */
module schema_sys

@[comment: ' 用户-角色关联表（多对多）']
@[table: 'pty_user_roles']
pub struct PtyUserRole {
pub:
	user_id string @[comment: '用户ID'; sql_type: 'CHAR(36)']
	role_id string @[comment: '角色ID'; sql_type: 'CHAR(36)']
}

/*
-- 用户-角色关联表（多对多）
CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);
*/
