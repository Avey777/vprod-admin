module main

// import time
// import sync
import internal.config

fn main() {
	banner()
	config.check_all()!

	server_thread := spawn new_app() // 启动服务器并处理错误
	/* 这里主线程可以做一些其他事情 */
	server_thread.wait() // 等待服务器线程完成并处理错误
}


// lsof -i :9009
// sudo kill -9 $(lsof -t -i :9009)

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
