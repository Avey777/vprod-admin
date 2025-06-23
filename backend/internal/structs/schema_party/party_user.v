module schema_party

import time

@[comment: '外部用户表']
@[table: 'party_users']
pub struct PartyUser {
pub:
	id            string  @[comment: 'UUID rand.uuid_v4()'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	username      string  @[comment: 'User`s login name | 登录名'; omitempty; required; sql: 'username'; sql_type: 'VARCHAR(255)'; unique: 'username']
	password      string  @[comment: 'Password | 密码'; omitempty; required; sql: 'password'; sql_type: 'VARCHAR(255)']
	nickname      string  @[comment: 'Nickname | 昵称'; omitempty; sql_type: 'VARCHAR(255)'; unique: 'nickname']
	description   ?string @[comment: 'The description of user | 用户的描述信息'; omitempty; sql_type: 'VARCHAR(255)']
	home_path     string  @[comment: 'The home page that the user enters after logging in | 用户登陆后进入的首页'; default: '"/dashboard"'; omitempty; sql_type: 'VARCHAR(255)']
	mobile        ?string @[comment: 'Mobile number | 手机号'; omitempty; sql_type: 'VARCHAR(255)']
	email         ?string @[comment: 'Email | 邮箱号'; omitempty; sql_type: 'VARCHAR(255)']
	avatar        ?string @[comment: 'Avatar | 头像路径'; omitempty; sql_type: 'VARCHAR(512)']
	department_id ?u64    @[comment: 'Department ID | 部门ID'; omitempty; optional; sql_type: 'VARCHAR(255)'; unique]
	status        u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

// type User struct {
//     Owner       string `xorm:"varchar(100) notnull pk" json:"owner"`
//     Name        string `xorm:"varchar(100) notnull pk" json:"name"`
//     CreatedTime string `xorm:"varchar(100)" json:"createdTime"`
//     UpdatedTime string `xorm:"varchar(100)" json:"updatedTime"`

//     Id                string   `xorm:"varchar(100)" json:"id"`
//     Type              string   `xorm:"varchar(100)" json:"type"`
//     Password          string   `xorm:"varchar(100)" json:"password"`
//     PasswordSalt      string   `xorm:"varchar(100)" json:"passwordSalt"`
//     DisplayName       string   `xorm:"varchar(100)" json:"displayName"`
//     Avatar            string   `xorm:"varchar(500)" json:"avatar"`
//     PermanentAvatar   string   `xorm:"varchar(500)" json:"permanentAvatar"`
//     Email             string   `xorm:"varchar(100) index" json:"email"`
//     Phone             string   `xorm:"varchar(100) index" json:"phone"`
//     Location          string   `xorm:"varchar(100)" json:"location"`
//     Address           []string `json:"address"`
//     Affiliation       string   `xorm:"varchar(100)" json:"affiliation"`
//     Title             string   `xorm:"varchar(100)" json:"title"`
//     IdCardType        string   `xorm:"varchar(100)" json:"idCardType"`
//     IdCard            string   `xorm:"varchar(100) index" json:"idCard"`
//     Homepage          string   `xorm:"varchar(100)" json:"homepage"`
//     Bio               string   `xorm:"varchar(100)" json:"bio"`
//     Tag               string   `xorm:"varchar(100)" json:"tag"`
//     Region            string   `xorm:"varchar(100)" json:"region"`
//     Language          string   `xorm:"varchar(100)" json:"language"`
//     Gender            string   `xorm:"varchar(100)" json:"gender"`
//     Birthday          string   `xorm:"varchar(100)" json:"birthday"`
//     Education         string   `xorm:"varchar(100)" json:"education"`
//     Score             int      `json:"score"`
//     Ranking           int      `json:"ranking"`
//     IsDefaultAvatar   bool     `json:"isDefaultAvatar"`
//     IsOnline          bool     `json:"isOnline"`
//     IsAdmin           bool     `json:"isAdmin"`
//     IsGlobalAdmin     bool     `json:"isGlobalAdmin"`
//     IsForbidden       bool     `json:"isForbidden"`
//     IsDeleted         bool     `json:"isDeleted"`
//     SignupApplication string   `xorm:"varchar(100)" json:"signupApplication"`
//     Hash              string   `xorm:"varchar(100)" json:"hash"`
//     PreHash           string   `xorm:"varchar(100)" json:"preHash"`

//     CreatedIp      string `xorm:"varchar(100)" json:"createdIp"`
//     LastSigninTime string `xorm:"varchar(100)" json:"lastSigninTime"`
//     LastSigninIp   string `xorm:"varchar(100)" json:"lastSigninIp"`

//     Github   string `xorm:"varchar(100)" json:"github"`
//     Google   string `xorm:"varchar(100)" json:"google"`
//     QQ       string `xorm:"qq varchar(100)" json:"qq"`
//     WeChat   string `xorm:"wechat varchar(100)" json:"wechat"`
//     Facebook string `xorm:"facebook varchar(100)" json:"facebook"`
//     DingTalk string `xorm:"dingtalk varchar(100)" json:"dingtalk"`
//     Weibo    string `xorm:"weibo varchar(100)" json:"weibo"`
//     Gitee    string `xorm:"gitee varchar(100)" json:"gitee"`
//     LinkedIn string `xorm:"linkedin varchar(100)" json:"linkedin"`
//     Wecom    string `xorm:"wecom varchar(100)" json:"wecom"`
//     Lark     string `xorm:"lark varchar(100)" json:"lark"`
//     Gitlab   string `xorm:"gitlab varchar(100)" json:"gitlab"`
//     Apple    string `xorm:"apple varchar(100)" json:"apple"`
//     AzureAD  string `xorm:"azuread varchar(100)" json:"azuread"`
//     Slack    string `xorm:"slack varchar(100)" json:"slack"`

//     Ldap       string            `xorm:"ldap varchar(100)" json:"ldap"`
//     Properties map[string]string `json:"properties"`
// }
