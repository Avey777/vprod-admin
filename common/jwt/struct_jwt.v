module jwt

pub struct JWT_Header {
	alg string // 加密(algorithm)：'HS256'，"none"
	typ string // (Type) Header Parameter
	cty string // (Content Type) Header Parameter
}

pub struct JWT_Payload {
	// 标准声明
	iss string   // 签发者 (Issuer) your-app-name
	sub string   // 用户唯一标识 (Subject)
	aud []string // 接收方 (Audience)，可以是数组或字符串
	exp i64      // 过期时间 (Expiration Time) 7天后
	nbf i64      // 生效时间 (Not Before)，立即生效
	iat i64      // 签发时间 (Issued At)
	jti string   // JWT唯一标识 (JWT ID)，防重防攻击
	// 自定义声明
	name      string   // 用户姓名
	roles     []string // 用户角色
	status    string   // 用户状态
	login_ip  string   // ip地址
	device_id string   // 设备id
}
