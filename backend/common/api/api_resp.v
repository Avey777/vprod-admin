module api

import rand

pub struct ApiErrorResponse {
pub:
	resp_id string
	status  bool
	code    int
	msg     string
}

pub struct ApiSuccessResponse[T] {
pub:
	resp_id string
	status  bool
	code    int
	msg     string
	result  T
}

pub fn json_success[T](message_success string, respose_data T) ApiSuccessResponse[T] {
	mut uuid := rand.uuid_v7()
	response := ApiSuccessResponse[T]{
		resp_id: uuid
		status:  true
		code:    0
		msg:     message_success
		result:  respose_data
	}
	return response
}

pub fn json_error(status_code int, message_error string) ApiErrorResponse {
	mut uuid := rand.uuid_v7()
	response := ApiErrorResponse{
		resp_id: uuid
		status:  false
		code:    status_code
		msg:     message_error
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
	// | f64
	| map[string]int
	| map[string]bool

@[params]
pub struct ApiErrorResponseOptparams {
pub:
	resp_id string
	status  bool
	code    int
	msg     string
	result  SumResp
}

pub fn json_success_optparams(c ApiErrorResponseOptparams) ApiErrorResponseOptparams {
	mut uuid := rand.uuid_v4()
	response := ApiErrorResponseOptparams{
		resp_id: uuid
		status:  true
		code:    0
		msg:     c.msg
		result:  c.result
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
