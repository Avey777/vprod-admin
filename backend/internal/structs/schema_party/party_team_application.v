module schema_party

import time

// 团队应用关系表（用于应用共享）
@[table: 'party_team_applications']
pub struct PartyTeamApplication {
pub:
    id             string    @[immutable; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: '关系ID']
    owner_team_id  string    @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '应用所有者团队ID']
    shared_team_id string    @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '被共享团队ID']
    application_id string    @[omitempty; required; sql_type: 'CHAR(36)'; zcomments: '应用ID']
    access_level   u8        @[default: 1; omitempty; sql_type: 'tinyint'; zcomments: '访问权限级别：0-只读，1-读写，2-管理员']

    updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
    updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
    creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
    created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
    del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
    deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
