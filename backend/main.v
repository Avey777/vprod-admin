module main

// import time
// import sync
import internal.handler
import internal.config

fn main() {
	config.check_all()! //启动前配置检查

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

	handler.new_app()
}

// lsof -i :9009
// sudo kill -9 $(lsof -t -i :9009)
