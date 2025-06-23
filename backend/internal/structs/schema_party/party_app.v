module schema_party

import time

@[table: 'party_applications']
@[comment: '应用表']
pub struct PartyApplication {
pub:
	id          string  @[comment: '应用ID'; immutable; primary; sql: 'id'; sql_type: 'CHAR(36)']
	name        string  @[comment: '应用名称'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'name']
	app_key     string  @[comment: '应用Key'; omitempty; required; sql_type: 'VARCHAR(255)'; unique: 'app_key']
	app_secret  string  @[comment: '应用Secret'; omitempty; required; sql_type: 'VARCHAR(255)']
	description ?string @[comment: '应用描述'; omitempty; sql_type: 'VARCHAR(512)']
	icon        ?string @[comment: '应用图标'; omitempty; sql_type: 'VARCHAR(512)']
	status      u8      @[comment: '状态，0：正常，1：禁用'; default: 0; omitempty; sql_type: 'tinyint']
	team_id     string  @[comment: '所属团队ID'; omitempty; required; sql_type: 'CHAR(36)']

	updater_id ?string    @[comment: '修改者ID'; omitempty; sql_type: 'CHAR(36)']
	updated_at time.Time  @[comment: 'Update Time | 修改日期'; omitempty; sql_type: 'TIMESTAMP']
	creator_id ?string    @[comment: '创建者ID'; immutable; omitempty; sql_type: 'CHAR(36)']
	created_at time.Time  @[comment: 'Create Time | 创建日期'; immutable; omitempty; sql_type: 'TIMESTAMP']
	del_flag   u8         @[comment: '删除标记，0：未删除，1：已删除'; default: 0; omitempty; sql_type: 'tinyint(1)']
	deleted_at ?time.Time @[comment: 'Delete Time | 删除日期'; omitempty; sql_type: 'TIMESTAMP']
}

// type Application struct {
//     Owner               string          `xorm:"varchar(100) notnull pk" json:"owner"`
//     Name                string          `xorm:"varchar(100) notnull pk" json:"name"`
//     CreatedTime         string          `xorm:"varchar(100)" json:"createdTime"`
//     DisplayName         string          `xorm:"varchar(100)" json:"displayName"`
//     Logo                string          `xorm:"varchar(100)" json:"logo"`
//     HomepageUrl         string          `xorm:"varchar(100)" json:"homepageUrl"`
//     Description         string          `xorm:"varchar(100)" json:"description"`
//     Organization        string          `xorm:"varchar(100)" json:"organization"`
//     Cert                string          `xorm:"varchar(100)" json:"cert"`
//     EnablePassword      bool            `json:"enablePassword"`
//     EnableSignUp        bool            `json:"enableSignUp"`
//     EnableSigninSession bool            `json:"enableSigninSession"`
//     EnableCodeSignin    bool            `json:"enableCodeSignin"`
//     Providers           []*ProviderItem `xorm:"mediumtext" json:"providers"`
//     SignupItems         []*SignupItem   `xorm:"varchar(1000)" json:"signupItems"`
//     OrganizationObj     *Organization   `xorm:"-" json:"organizationObj"`
//     ClientId             string         `xorm:"varchar(100)" json:"clientId"`
//     ClientSecret         string         `xorm:"varchar(100)" json:"clientSecret"`
//     RedirectUris         []string       `xorm:"varchar(1000)" json:"redirectUris"`
//     TokenFormat          string         `xorm:"varchar(100)" json:"tokenFormat"`
//     ExpireInHours        int            `json:"expireInHours"`
//     RefreshExpireInHours int            `json:"refreshExpireInHours"`
//     SignupUrl            string         `xorm:"varchar(200)" json:"signupUrl"`
//     SigninUrl            string         `xorm:"varchar(200)" json:"signinUrl"`
//     ForgetUrl            string         `xorm:"varchar(200)" json:"forgetUrl"`
//     AffiliationUrl       string         `xorm:"varchar(100)" json:"affiliationUrl"`
//     TermsOfUse           string         `xorm:"varchar(100)" json:"termsOfUse"`
//     SignupHtml           string         `xorm:"mediumtext" json:"signupHtml"`
//     SigninHtml           string         `xorm:"mediumtext" json:"signinHtml"`
// }
