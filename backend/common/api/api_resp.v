module api

import rand

pub struct ValidationError {
pub:
	field string
	msg   string //使用 message 更符合RESTful 接口规范
	rule  string
	meta  map[string]string // 扩展参数（如 { "min": ’8‘, "max": 20 }）
}

pub struct ApiErrorResponse {
pub:
	code       int
	status     bool
	request_id string
	error      string
	details    ?[]ValidationError //暂时未使用，待未来扩展
}

pub struct ApiSuccessResponse[T] {
pub:
	code       int
	status     bool
	request_id string
	data       T
}

pub fn json_success[T](c ApiSuccessResponse[T]) ApiSuccessResponse[T] {
	mut uuid := rand.uuid_v7()
	response := ApiSuccessResponse[T]{
		code:       c.code
		status:     true
		request_id: uuid
		data:       c.data
	}
	return response
}

pub fn json_error(c ApiErrorResponse) ApiErrorResponse {
	mut uuid := rand.uuid_v7()
	response := ApiErrorResponse{
		code:       c.code
		status:     false
		request_id: uuid
		error:      c.error
	}
	return response
}

// /*******可选参支持 - 支持泛型*******->*/

@[params]
pub struct ApiSuccessResponseOptparams[T] {
pub:
	request_id string
	status     bool
	code       int
	data       T
}

pub fn json_success_optparams[T](c ApiSuccessResponseOptparams[T]) ApiSuccessResponseOptparams[T] {
	mut uuid := rand.uuid_v4()
	response := ApiSuccessResponseOptparams[T]{
		request_id: uuid
		status:     true
		code:       c.code
		data:       c.data
	}
	return response
}
