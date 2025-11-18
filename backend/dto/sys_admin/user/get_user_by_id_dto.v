module user

pub struct UserByIdReq {
pub mut:
	user_id string
}

pub struct UserByIdResp {
pub mut:
	datalist []UserById
}

pub struct UserById {
pub mut:
	id         string
	username   string
	nickname   string
	status     u8
	role_ids   []string
	role_names []string
	avatar     string
	desc       string
	home_path  string
	mobile     string
	email      string
	creator_id string
	updater_id string
	created_at string
	updated_at string
	deleted_at string
}
