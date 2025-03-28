module config

const data = "[web]
port = 9009

[i18nconf]
Dir = './internal/i18n'

# [dbconf]
# type = 'mysql'            # mysql  tidb
# host = '127.0.0.1'
# port = '3306'
# username = 'root'
# password = 'mysql_123456'
# dbname = 'vcore'
# ssl_verify = false #设置为false 时，不验证ssl证书


[dbconf]
type = 'tidb'
host = 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com'
port = '4000'
username = 'xfQRtLXKTtPHsUi.root'
password = 'GkFU6Q3uvt0O9F0A'
dbname = 'vcore'
ssl_verify = true                                        #设置为true时，验证ssl证书
ssl_key = ''
ssl_cert = ''
ssl_ca = './etc/client-cert.pem'
ssl_capath = ''
ssl_cipher = ''
"
