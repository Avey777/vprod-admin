module config

import time

// 嵌套配置结构体
pub struct Config {
pub:
	web        WebConf
	dbconf_sys DBConf
	dbconf_pay DBConf
}

//[veb]
pub struct WebConf {
pub:
	port    int
	timeout int
}

//[dbconf]
pub struct DBConf {
pub:
	type       string
	host       string
	port       string
	username   string
	password   string
	dbname     string
	ssl_verify bool @[default: false] // #设置为true时，验证ssl证书
	ssl_key    string
	ssl_cert   string
	ssl_ca     string
	ssl_capath string
	ssl_cipher string
}

// MiddlewaresConf is the config of middlewares.
pub struct MddlewaresConf {
pub:
	trace      bool @[default: true; json: 'Trace']      // Enable trace middleware
	log        bool @[default: true; json: 'Log']        // 日志中间件
	prometheus bool @[default: true; json: 'Prometheus'] // Enable prometheus middleware
	max_conns  bool @[default: true; json: 'MaxConns']   // Enable max connections middleware
	breaker    bool @[default: true; json: 'Breaker']    // Enable circuit breaker middleware
	shedding   bool @[default: true; json: 'Shedding']   // Enable shedding middleware
	timeout    bool @[default: true; json: 'Timeout']    // 超时中间件
	recover    bool @[default: true; json: 'Recover']    // Enable recover middleware
	metrics    bool @[default: true; json: 'Metrics']    // Enable metrics middleware
	max_bytes  bool @[default: true; json: 'MaxBytes']   // Enable max bytes middleware
	gunzip     bool @[default: true; json: 'Gunzip']     // Enable gunzip middleware
	i18n       bool @[default: true; json: 'I18n']       // Enable i18n middleware
	tenant     bool @[default: false; json: 'Tenant']    // Enable tenant middleware
	client_ip  bool @[default: false; json: 'ClientIP']  // Enable client IP middleware
}

// A PrivateKeyConf is a private key config.
struct PrivateKeyConf {
	fingerprint string
	key_file    string
}

// A SignatureConf is a signature config.
struct SignatureConf {
	strict       bool          @[default: false; json: 'Strict'] // Enable strict signature validation
	expiry       time.Duration @[default: 1; json: 'Expiry']     // Set the duration for signature expiry
	private_keys []PrivateKeyConf // Configure private keys for signature validation
}

// AuthConf is a JWT config
struct AuthConf {
	access_secret string @[json: 'optional,env=AUTH_SECRET'] // Configure access secret for JWT authentication
	access_expire i64    @[json: 'optional,env=AUTH_EXPIRE'] // Configure access expiration time for JWT authentication
}

/* A RestConf is a http service config.
Why not name it as Conf, because we need to consider usage like:
 type Config struct {
    zrpc.RpcConf
    rest.RestConf
 }
if with the name Conf, there will be two Conf inside Config */
struct RestConf {
	// service.ServiceConf
	host          string        @[json: 'default=0.0.0.0,env=API_HOST']      // Configure host address for HTTP service
	port          int           @[json: 'env=API_PORT']                      // Configure port number for HTTP service
	cert_file     string        @[json: 'optional,env=API_CERT_FILE']        // Configure certificate file for HTTPS service
	key_file      string        @[json: 'optional,env=API_KEY_FILE']         // Configure key file for HTTPS service
	verbose       bool          @[json: 'optional,env=API_VERBOSE']          // Configure verbose mode for HTTP service
	mmax_conns    int           @[json: 'default=10000,env=API_MAX_CONNS']   // Configure maximum number of concurrent connections for HTTP service
	max_bytes     i64           @[json: 'default=1048576,env=API_MAX_BYTES'] // Configure maximum request body size for HTTP service
	timeout       i64           @[json: 'default=3000,env=API_TIMEOUT']      // [milliseconds] Configure timeout for HTTP service
	cpu_threshold i64           @[json: 'default=900,range=[0:1000)']
	signature     SignatureConf @[json: 'optional,env=API_SIGNATURE']
	// middlewares        MiddlewaresConf // There are default values for all the items in Middlewares
	trace_ignore_paths []string @[json: 'optional'] // TraceIgnorePaths is paths blacklist for trace middleware
}
