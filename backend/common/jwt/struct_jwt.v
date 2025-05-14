module jwt

pub struct JwtHeader {
pub:
	alg string // 加密(algorithm)：'HS256'，"none"
	typ string // (Type) Header Parameter
	cty string // (Content Type) Header Parameter
}

pub struct JwtPayload {
pub:
	// 标准声明
	iss string   // 签发者 (Issuer) App名称
	sub string   // 接收方-用户/租户唯一标识 (Subject)  用户id
	aud []string // 接收方 (Audience)，可以是数组或字符串 ["团队id"，"应用系统id","应用-门户id"]
	exp i64      // 过期时间 (Expiration Time) 7天后
	nbf i64      // 生效时间 (Not Before)，立即生效
	iat i64      // 签发时间 (Issued At)
	jti string   // JWT唯一标识 (JWT ID)，防重防攻击
	// 自定义声明
	name      string   // 用户/租户姓名
	roles     []string // 用户/租户角色
	status    string   // 用户/租户账号状态
	login_ip  string   // ip地址
	device_id string   // 设备id
	// 团队id
	// 应用系统id
	// 应用-门户id
}
