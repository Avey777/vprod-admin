/* party(pty): 客户、供应商、合作伙伴 */
module schema_pty

// import time

// 应用门户关系表 (解决多对多关系)
@[comment: '应用-门户关系表']
@[table: 'pty_app_portals']
pub struct PtyAppPortals {
pub:
	application_owner string @[comment: '应用所有者'; foreign: 'applications.owner'; primary; required]
	application_name  string @[comment: '应用名称'; foreign: 'applications.name'; primary; required]
	portal_id         string @[comment: '门户ID'; foreign: 'portals.id'; index; primary; required]
	is_default        bool   @[comment: '是否默认门户'; default: false]
	sort_order        int    @[comment: '排序顺序'; default: 0]
}
