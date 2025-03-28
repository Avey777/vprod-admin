module db_pool

// 连接池配置
struct Config {
	max_size     int = 5         // 最大连接数
	max_idle     int = 3         // 最大空闲连接
	max_lifetime int = 30 * 1000 // 连接最大存活时间(毫秒)
}

// 数据库连接池
struct ConnectionPool {
mut:
	config  Config
	conns   []orm.Connection     // 可用连接列表
	active  int                  // 活跃连接数
	mu      sync.Mutex           // 线程安全锁
	factory fn () orm.Connection // 连接创建工厂
}
