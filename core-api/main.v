module main

import internal.handler { new_app }
// import config
import log
// import time
// import sync
import os

fn main() {
	mut l := log.Log{}
	l.set_output_stream(os.stdout())
	// check_all() //启动前配置检查

	// // 定义全局互斥锁
	// mut mx := sync.Mutex{}
	// // 使用协程运行定时任务
	// go fn [mut mx] () {
	// 	for {
	// 		mx.@lock() // 加锁
	// 		defer {
	// 			mx.unlock() // 解锁
	// 		}

	// cr_task_images() or { log.warn('cr_task_images jump: ${err}') }
	// up_task_images() or { log.warn('up_task_images jump: ${err}') }
	// time.sleep(10 * time.second)
	// 	}
	// }()

	new_app()
}

// import test {start}
// fn main() {
// 	start()
// }
