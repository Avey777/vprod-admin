module config

import time

// MiddlewaresConf is the config of middlewares.
struct MddlewaresConf {
	Trace      bool @['default=true'; json: 'trace']
	Log        bool @['default=true'; json: 'Log']
	Prometheus bool @['default=true'; json: 'Prometheus']
	MaxConns   bool @['default=true'; json: 'MaxConns']
	Breaker    bool @['default=true'; json: 'Breaker']
	Shedding   bool @['default=true'; json: 'Shedding']
	Timeout    bool @['default=true'; json: 'Timeout']
	Recover    bool @['default=true'; json: 'Recover']
	Metrics    bool @['default=true'; json: 'Metrics']
	MaxBytes   bool @['default=true'; json: 'MaxBytes']
	Gunzip     bool @['default=true'; json: 'Gunzip']
	I18n       bool @['default=true'; json: 'I18n']
	Tenant     bool @['default=false'; json: 'Tenant']
	ClientIP   bool @['default=false'; json: 'ClientIP']
}

// A PrivateKeyConf is a private key config.
struct PrivateKeyConf {
	fingerprint string
	key_file    string
}

// A SignatureConf is a signature config.
struct SignatureConf {
	Strict       bool          @['default=false'; json: 'Strict']
	Expiry       time.Duration @['default=1h'; json: 'Expiry']
	Private_keys []PrivateKeyConf
}

// AuthConf is a JWT config
struct AuthConf {
	Access_secret string @[json: 'optional,env=AUTH_SECRET']
	Access_expire i64    @[json: 'optional,env=AUTH_EXPIRE']
}

/*
A RestConf is a http service config.
Why not name it as Conf, because we need to consider usage like:
 type Config struct {
    zrpc.RpcConf
    rest.RestConf
 }
if with the name Conf, there will be two Conf inside Config.
*/
struct RestConf {
	service.ServiceConf
	Host     string @[json: 'default=0.0.0.0,env=API_HOST']
	Port     int    @[json: 'env=API_PORT']
	CertFile string @[json: 'optional,env=API_CERT_FILE']
	KeyFile  string @[json: 'optional,env=API_KEY_FILE']
	Verbose  bool   @[json: 'optional,env=API_VERBOSE']
	MaxConns int    @[json: 'default=10000,env=API_MAX_CONNS']
	MaxBytes int64  @[json: 'default=1048576,env=API_MAX_BYTES']
	// milliseconds
	Timeout      int64         @[json: 'default=3000,env=API_TIMEOUT']
	CpuThreshold int64         @[json: 'default=900,range=[0:1000)']
	Signature    SignatureConf @[json: 'optional,env=API_SIGNATURE']
	// There are default values for all the items in Middlewares.
	Middlewares MiddlewaresConf
	// TraceIgnorePaths is paths blacklist for trace middleware.
	TraceIgnorePaths []string @[json: 'optional']
}
