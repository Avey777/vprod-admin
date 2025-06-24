module schema_party

// import time

// 应用门户关系表 (解决多对多关系)
@[comment: '应用-门户关系表']
@[table: 'application_portals']
pub struct ApplicationPortal {
pub:
	application_owner string @[comment: '应用所有者'; foreign: 'applications.owner'; primary; required]
	application_name  string @[comment: '应用名称'; foreign: 'applications.name'; primary; required]
	portal_id         string @[comment: '门户ID'; foreign: 'portals.id'; index; primary; required]
	is_default        bool   @[comment: '是否默认门户'; default: false]
	sort_order        int    @[comment: '排序顺序'; default: 0]
}
