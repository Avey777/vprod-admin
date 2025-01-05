module api_structs

pub struct ApiErrorResponse {
pub:
	status     bool
	code       int
	request_id string
	message    string
}

pub struct ApiSuccessResponse[T] {
pub:
	status     bool
	code       int
	request_id string
	result     T
}
