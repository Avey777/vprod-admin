// vtest build: !(macos || windows)
import db.mysql
import pool
import time

struct DBConnectionPool {
mut:
    db_pool &pool.ConnectionPool
}

// 创建新的数据库连接池实例
pub fn new_db_conn_pool(create_conn fn () !&pool.ConnectionPoolable, config pool.ConnectionPoolConfig) !&DBConnectionPool {
    db_pool := pool.new_connection_pool(create_conn, config)!
    return &DBConnectionPool{
        db_pool: db_pool
    }
}

// 获取数据库连接
pub fn (mut p DBConnectionPool) acquire() !&pool.ConnectionPoolable {
    conn := p.db_pool.get()!
    return conn
}

// 归还数据库连接
pub fn (mut p DBConnectionPool) release(conn &pool.ConnectionPoolable) ! {
    p.db_pool.put(conn)!
}

// 关闭连接池
pub fn (mut p DBConnectionPool) close() {
    p.db_pool.close()
}

// 定义连接创建函数
fn create_conn() !&pool.ConnectionPoolable {
    config := mysql.Config{
        host:     'mysql2.sqlpub.com'
        port:     3307
        username: 'vcore_test'
        password: 'wfo8wS7CylT0qIMg'
        dbname:   'vcore_test'
    }
    db := mysql.connect(config)!
    return &db
}

fn main() {
    // 配置连接池参数
    config := pool.ConnectionPoolConfig{
        max_conns:      50
        min_idle_conns: 5
        max_lifetime:   2 * time.hour
        idle_timeout:   30 * time.minute
        get_timeout:    5 * time.second
    }

    // 创建数据库连接池实例
    mut db_manager := new_db_conn_pool(create_conn, config)!
    defer {
        // 应用程序退出时关闭连接池
        db_manager.close()
    }

    // 获取连接
    mut conn := db_manager.acquire()!
    defer {
        // 确保连接归还
        db_manager.release(conn) or { println(err) }
    }

    // // 使用连接
    dump(conn)
    mut db := conn as mysql.DB
    dump(db)
    assert db.validate()!
}
