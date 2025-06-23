module schema_sys

@[table: 'sys_casbin_rules']
@[comment: 'Casbin 规则表']
pub struct SysCasbinRule {
pub:
	id    string @[comment: 'UUID'; primary; serial; sql: 'id'; sql_type: 'CHAR(36)']
	ptype string @[comment: '策略类型 (p/g)'; default: ''; omitempty; required; sql: 'ptype'; sql_type: 'VARCHAR(255)']
	v0    string @[comment: '规则字段0'; default: ''; omitempty; required; sql: 'v0'; sql_type: 'VARCHAR(255)']
	v1    string @[comment: '规则字段1'; default: ''; omitempty; required; sql: 'v1'; sql_type: 'VARCHAR(255)']
	v2    string @[comment: '规则字段2'; default: ''; omitempty; required; sql: 'v2'; sql_type: 'VARCHAR(255)']
	v3    string @[comment: '规则字段3'; default: ''; omitempty; required; sql: 'v3'; sql_type: 'VARCHAR(255)']
	v4    string @[comment: '规则字段4'; default: ''; omitempty; required; sql: 'v4'; sql_type: 'VARCHAR(255)']
	v5    string @[comment: '规则字段5'; default: ''; omitempty; required; sql: 'v5'; sql_type: 'VARCHAR(255)']
}
