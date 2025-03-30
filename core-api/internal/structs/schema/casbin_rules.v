module schema

// Casbin 规则表
@[table: 'casbin_rules']
pub struct CasbinRule {
pub:
	id    string @[primary; serial; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	ptype string @[default: ''; omitempty; required; sql: 'ptype'; sql_type: 'VARCHAR(255)'; zcomments: '策略类型 (p/g)']
	v0    string @[default: ''; omitempty; required; sql: 'v0'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段0']
	v1    string @[default: ''; omitempty; required; sql: 'v1'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段1']
	v2    string @[default: ''; omitempty; required; sql: 'v2'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段2']
	v3    string @[default: ''; omitempty; required; sql: 'v3'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段3']
	v4    string @[default: ''; omitempty; required; sql: 'v4'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段4']
	v5    string @[default: ''; omitempty; required; sql: 'v5'; sql_type: 'VARCHAR(255)'; zcomments: '规则字段5']
}
