module main

import veb
import sync
import os
import time

// ------------------ 上下文结构体 ------------------
pub struct Context {
	veb.Context
}

// ------------------ 应用结构体 ------------------
pub struct App {
	veb.Middleware[Context]
	veb.Controller
	veb.StaticHandler
pub mut:
	started       chan bool  // 服务已启动信号（未使用，但保留）
	shutdown_ch   chan bool  // 接收关闭请求的通道
	inflight      int        // 当前正在处理的请求数量
	shutting_down bool       // 标记是否正在关闭中
	mu            sync.Mutex // 保护 inflight 和 shutting_down 的互斥锁
	inflight_zero chan bool  // 当 inflight 变为 0 时发送通知
	admin_token   string     // 管理员令牌，用于触发 HTTP 关机（与 Authorization header 比对）
	// 配置
	shutdown_wait_secs int // 最长等待正在处理请求完成的秒数
}

// ------------------ 中间件注册函数（仅拒绝新请求） ------------------
fn register_track_requests(mut app App) {
	// 中间件只负责拒绝在 shutting_down 状态下的新请求
	app.use(
		handler: fn [mut app] (mut ctx Context) bool {
			app.mu.lock()
			if app.shutting_down {
				app.mu.unlock()
				ctx.res.set_status(.service_unavailable)
				ctx.text('server is shutting down')
				eprintln('[middleware] 请求拒绝：服务器正在关闭')
				return false
			}
			app.mu.unlock()
			return true // 继续处理请求（handler 里会维护 inflight）
		}
	)
}

// ------------------ 路由处理函数（在 handler 中管理 inflight） ------------------
@['/index'; get; post]
pub fn (mut app App) index(mut ctx Context) veb.Result {
	// 检查并增加 inflight（确保计数覆盖 handler 执行）
	app.mu.lock()
	if app.shutting_down {
		app.mu.unlock()
		ctx.res.set_status(.service_unavailable)
		return ctx.text('server is shutting down')
	}
	app.inflight++
	eprintln('[handler:index] 请求开始，inflight=${app.inflight}')
	app.mu.unlock()

	// 确保处理结束后减少计数并在需要时通知 shutdown
	defer {
		app.mu.lock()
		app.inflight--
		eprintln('[handler:index] 请求结束，inflight=${app.inflight}')
		if app.shutting_down && app.inflight == 0 {
			eprintln('[handler:index] inflight 为 0，通知关闭监听器（非阻塞）')
			go fn (ch chan bool) {
				ch <- true
			}(app.inflight_zero)
		}
		app.mu.unlock()
	}

	time.sleep(1 * time.second) // 模拟处理
	return ctx.text('Hello, world!')
}

@['/slow'; get; post]
pub fn (mut app App) slow(mut ctx Context) veb.Result {
	// 同样在这里管理 inflight，保证计数涵盖慢请求
	app.mu.lock()
	if app.shutting_down {
		app.mu.unlock()
		ctx.res.set_status(.service_unavailable)
		return ctx.text('server is shutting down')
	}
	app.inflight++
	eprintln('[handler:slow] 请求开始，inflight=${app.inflight}')
	app.mu.unlock()

	defer {
		app.mu.lock()
		app.inflight--
		eprintln('[handler:slow] 请求结束，inflight=${app.inflight}')
		if app.shutting_down && app.inflight == 0 {
			eprintln('[handler:slow] inflight 为 0，通知关闭监听器（非阻塞）')
			go fn (ch chan bool) {
				ch <- true
			}(app.inflight_zero)
		}
		app.mu.unlock()
	}

	eprintln('[slow] 业务开始（将睡 20s）')
	time.sleep(10 * time.second) // 模拟慢请求
	eprintln('[slow] 业务结束')
	return ctx.text('slow response done')
}

// 管理端点触发关机（使用 Authorization: Bearer <token>）
@['/admin/shutdown'; post]
pub fn (mut app App) admin_shutdown(mut ctx Context) veb.Result {
	// 读取 Authorization header（使用 Header.get）
	auth := ctx.req.header.get(.authorization) or { '' }
	mut token := ''
	if auth.len >= 7 && auth[..7] == 'Bearer ' {
		token = auth[7..]
	}
	if token == '' {
		// 兼容旧方式（query）——但优先使用 Authorization
		token = ctx.query['token']
	}
	if token != app.admin_token {
		ctx.res.set_status(.unauthorized)
		return ctx.text('unauthorized')
	}
	eprintln('[http] shutdown requested (admin)')
	// 非阻塞地触发关闭监听器
	go fn (ch chan bool) {
		ch <- true
	}(app.shutdown_ch)
	return ctx.text('shutdown initiated')
}

// ------------------ 关闭逻辑（包含超时等待 & 尝试优雅退出） ------------------
fn (mut app App) start_shutdown() {
	eprintln('[shutdown] starting')
	app.mu.lock()
	app.shutting_down = true
	// 如果此时没有正在处理的请求，可以直接优雅退出
	if app.inflight == 0 {
		app.mu.unlock()
		eprintln('[shutdown] no inflight requests, performing graceful exit')
		perform_graceful_exit()
		return
	}
	app.mu.unlock()

	// 等待 inflight 变为 0 或超时
	start := time.now()
	mut wait_secs := app.shutdown_wait_secs
	if wait_secs <= 0 {
		wait_secs = 30 // 默认 30s
	}
	for {
		app.mu.lock()
		if app.inflight == 0 {
			app.mu.unlock()
			eprintln('[shutdown] inflight requests completed before timeout')
			perform_graceful_exit()
			return
		}
		app.mu.unlock()

		// 检查是否超时：使用 time subtraction operator，得到 Duration
		elapsed := time.now() - start
		if elapsed > time.Duration(wait_secs) * time.second {
			eprintln('[shutdown] timeout waiting for inflight requests, forcing exit')
			// 超时强制退出（尽量先尝试优雅退出再强杀）
			perform_graceful_exit()
			return
		}

		time.sleep(200 * time.millisecond) // 短暂轮询
	}
}

// 尝试优雅退出的 hook：如果 veb 提供类似的 API，可以在这里调用并替换实现。
fn perform_graceful_exit() {
	eprintln('[shutdown] attempting graceful shutdown (fallback: exit)')
	// TODO: 如果 veb 提供优雅关闭 API，替换下面的 exit(0) 为对应调用，例如：
	//    veb.shutdown() 或 app.shutdown()
	// 目前为了兼容所有 veb 版本，这里调用 exit(0) 作为最终退出手段。
	exit(0)
}

// 监听 shutdown_ch 的协程
fn shutdown_listener(mut app App) {
	_ = <-app.shutdown_ch
	app.start_shutdown()
}

// ------------------ 主函数 ------------------
fn main() {
	mut app := &App{
		started:            chan bool{cap: 1}
		shutdown_ch:        chan bool{cap: 1}
		inflight_zero:      chan bool{cap: 1}
		admin_token:        'letmein'
		shutdown_wait_secs: 30
	}

	// 注册中间件（只负责拒绝新请求）
	register_track_requests(mut app)

	// 系统信号处理（Ctrl+C / TERM）
	os.signal_opt(.int, fn [mut app] (_ os.Signal) {
		// 通过 channel 触发关闭流程（非阻塞）
		go fn (ch chan bool) {
			ch <- true
		}(app.shutdown_ch)
	}) or { panic(err) }

	os.signal_opt(.term, fn [mut app] (_ os.Signal) {
		go fn (ch chan bool) {
			ch <- true
		}(app.shutdown_ch)
	}) or { panic(err) }

	// 启动关闭监听协程
	go shutdown_listener(mut app)

	// 启动服务器（端口 8080）
	veb.run[App, Context](mut app, 8080)
}
