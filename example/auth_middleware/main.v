import veb
import net.http
import net.urllib

// 1. 定义用户角色和权限（通常来自数据库）
enum Role {
	admin
	editor
	viewer
}

// 模拟用户数据
struct User {
	id       int
	username string
	role     Role
}

// 路由权限映射
const route_permissions = {
	'/admin/users': [Role.admin] // 只有管理员可访问用户管理
	'/admin/posts': [Role.admin, Role.editor] // 管理员和编辑可访问文章管理
	'/api/data':    [Role.admin, Role.editor, Role.viewer] // 所有登录用户可访问
}

// 2. 定义 Context 结构体，嵌入 veb.Context
pub struct Context {
	veb.Context
mut:
	user ?User // 当前登录用户（可选）
}

// 3. 定义 App 结构体，包含权限映射和中间件
pub struct App {
	veb.Middleware[Context]
}

// 4. 初始化应用和路由权限映射
fn main() {
	mut app := &App{}
	println('Starting veb app on port 8081')
	// Register middleware
	app.use(veb.MiddlewareOptions[Context]{ handler: auth_middleware })
	// Use App as the app type, Context as the context type
	veb.run[App, Context](mut app, 8081)
}

// 5. 实现认证和授权中间件
fn auth_middleware(mut ctx Context) bool {
	// debug
	println('DEBUG: auth_middleware called, raw url="${ctx.req.url}", method="${ctx.req.method.str()}"')

	// 5.1 跳过登录路由和静态文件的认证
	// extract path from request URL (strip query)
	parsed := urllib.parse(ctx.req.url) or { urllib.URL{} }
	mut path := parsed.path
	if path == '/login' || path == '/favicon.ico' {
		return true
	}

	// 5.2 获取并验证用户 Token（示例从 Header 获取）
	mut auth_header := ''
	// 从请求头读取 Authorization（req.header）
	auth_header = ctx.req.header.get_custom('Authorization', http.HeaderQueryConfig{ exact: false }) or {
		''
	}

	if auth_header.len == 0 || !auth_header.starts_with('Bearer ') {
		ctx.res.status_code = 401
		ctx.json({
			'error': 'Missing or invalid authentication token'
		})
		return false
	}

	token := auth_header['Bearer '.len..] // 提取 Token
	println('DEBUG: extracted token="' + token + '"')
	user := get_user_from_token(token) or {
		ctx.res.status_code = 401
		ctx.json({
			'error': 'Invalid token'
		})
		return false
	}
	ctx.user = user

	// 5.3 检查当前用户是否有访问当前路径的权限
	if !check_permission(ctx, path) {
		ctx.res.status_code = 403
		ctx.json({
			'error': 'You do not have permission to access this resource'
		})
		return false
	}

	// 认证和授权通过，继续处理请求
	return true
}

// 6. 权限检查逻辑
fn check_permission(ctx &Context, route_path string) bool {
	// 6.1 如果该路由未设置权限要求，默认允许访问
	required_roles := route_permissions[route_path] or { return true }

	// 6.2 如果用户已登录且其角色在所需角色列表中，则允许访问
	if user := ctx.user {
		return user.role in required_roles
	}

	return false
}

// 6. 模拟从 Token 获取用户信息（实际应查询数据库或缓存）
fn get_user_from_token(token string) ?User {
	// 这里应使用 JWT 解析或查询数据库来验证 token 并获取用户信息
	// 此处为示例，硬编码几个用户
	match token {
		'admin_token_123' {
			return User{
				id:       1
				username: 'admin'
				role:     .admin
			}
		}
		'editor_token_456' {
			return User{
				id:       2
				username: 'editor'
				role:     .editor
			}
		}
		'viewer_token_789' {
			return User{
				id:       3
				username: 'viewer'
				role:     .viewer
			}
		}
		else {
			return none
		}
	}
}

// 7. 定义需要权限保护的路由
@['/admin/users'; get]
pub fn (mut app App) admin_users(mut ctx Context) veb.Result {
	println('DEBUG: handler admin_users entered')
	// authentication/authorization handled in before_request
	return ctx.json({
		'message': 'Welcome to user management'
	})
}

@['/admin/posts'; get]
pub fn (mut app App) admin_posts(mut ctx Context) veb.Result {
	println('DEBUG: handler admin_posts entered')
	// authentication/authorization handled in before_request
	return ctx.json({
		'message': 'Post management panel'
	})
}

@['/api/data'; get]
pub fn (mut app App) api_data(mut ctx Context) veb.Result {
	println('DEBUG: handler api_data entered')
	// authentication/authorization handled in before_request
	return ctx.json({
		'data': [1, 2, 3, 4, 5]
	})
}

// 8. 登录路由（不需要权限）
@['/login'; post]
pub fn (mut app App) login(mut ctx Context) veb.Result {
	println('DEBUG: handler login entered, method=${ctx.req.method.str()}, url=${ctx.req.url}')
	return ctx.json({
		'token': 'admin_token_123'
	})
}
