module main

type Any = string | int | f64 | bool | []map[string]Any

fn main() {
	// 创建 map[string]any 的切片
	mut data_list := []map[string]Any{}

	mut item := map[string]Any{}
	item['name'] = 'name'
	item['age'] = 1
	data_list << item
	dump(data_list)

	mut result := map[string]Any{}
	result['account'] = 123
	result['data'] = data_list

	dump(result)
}
