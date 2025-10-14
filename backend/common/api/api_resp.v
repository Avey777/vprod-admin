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
	msg        string //使用 message 更符合RESTful 接口规范
	data       T
}

pub fn json_success[T](status_code int, message_success string, respose_data T) ApiSuccessResponse[T] {
	mut uuid := rand.uuid_v7()
	response := ApiSuccessResponse[T]{
		code:       status_code
		status:     true
		request_id: uuid
		msg:        message_success
		data:       respose_data
	}
	return response
}

pub fn json_error(status_code int, message_error string) ApiErrorResponse {
	mut uuid := rand.uuid_v7()
	response := ApiErrorResponse{
		code:       status_code
		status:     false
		request_id: uuid
		error:      message_error
	}
	return response
}

// /*******可选参支持 - 不支持泛型*******->*/
type SumResp = []string
	| string
	| bool
	| map[string]string
	| []int
	| int
	| map[string]int
	| map[string]bool

// | f64

@[params]
pub struct ApiErrorResponseOptparams {
pub:
	request_id string
	status     bool
	code       int
	message    string
	data       SumResp
}

pub fn json_success_optparams(c ApiErrorResponseOptparams) ApiErrorResponseOptparams {
	mut uuid := rand.uuid_v4()
	response := ApiErrorResponseOptparams{
		request_id: uuid
		status:     true
		code:       c.code
		message:    c.message
		data:       c.data
	}
	return response
}

// //解决和类型 int 与 f64 在json中不能同时使用的问题
// pub fn json_success_optparams(a ApiErrorResponseOptparams) string {
// 	mut res := '{'
// 	res += '"resp_id": "${a.resp_id}",'
// 	res += '"status": ${a.status},'
// 	res += '"code": ${a.code},'
// 	res += '"msg": "${a.msg}",'

// 	res += '"result": '
// 	if a.result is []string {
// 		res += '['
// 		for i, s in a.result {
// 			res += '"${s}"'
// 			if i < a.result.len - 1 {
// 				res += ','
// 			}
// 		}
// 		res += ']'
// 	} else if a.result is string {
// 		res += '"${a.result}"'
// 	}

// 	res += '}'
// 	return res
// }

// /*******可选参支持 - 不支持泛型*******<-*/
