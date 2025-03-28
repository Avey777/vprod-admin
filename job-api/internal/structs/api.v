module structs

import rand

pub struct ApiErrorResponse {
pub:
	status  bool
	code    int
	resp_id string
	msg     string
}

pub struct ApiSuccessResponse[T] {
pub:
	status bool
	code   int
	req_id string
	result T
}

pub fn json_success[T](status_code int, respose_data T) ApiSuccessResponse[T] {
	mut uuid := rand.uuid_v4()
	response := ApiSuccessResponse[T]{
		status:  true
		code:    status_code
		resp_id: uuid
		result:  respose_data
	}

	return response
}

pub fn json_error(status_code int, message_error string) ApiErrorResponse {
	mut uuid := rand.uuid_v4()
	response := ApiErrorResponse{
		status:  false
		code:    status_code
		resp_id: uuid
		msg:     message_error
	}

	return response
}
