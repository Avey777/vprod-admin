module pay

import time

// 支付订单扩展表
@[table: 'pay_order_extension']
pub struct PayOrderExtension {
pub:
	id                  string  @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	no                  string  @[omitempty; required; sql: 'no'; sql_type: 'VARCHAR(255)'; zcomments: '支付订单号']
	order_id            string  @[omitempty; required; sql: 'order_id'; sql_type: 'CHAR(36)'; zcomments: '渠道编号']
	channel_code        string  @[omitempty; required; sql: 'channel_code'; sql_type: 'VARCHAR(255)'; zcomments: '渠道编码']
	user_ip             string  @[omitempty; required; sql: 'user_ip'; sql_type: 'VARCHAR(255)'; zcomments: '用户 IP']
	channel_extras      ?string @[omitempty; sql: 'channel_extras'; sql_type: 'json'; zcomments: '支付渠道的额外参数']
	channel_error_code  ?string @[omitempty; sql: 'channel_error_code'; sql_type: 'VARCHAR(255)'; zcomments: '调用渠道的错误码']
	channel_error_msg   ?string @[omitempty; sql: 'channel_error_msg'; sql_type: 'VARCHAR(255)'; zcomments: '调用渠道报错时，错误信息']
	channel_notify_data ?string @[omitempty; sql: 'channel_notify_data'; sql_type: 'longtext'; zcomments: '支付渠道异步通知的内容']
	status              u8      @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
