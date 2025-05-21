module schema_pay

import time

// 支付订单表
@[table: 'pay_order']
pub struct PayOrder {
pub:
	id                string     @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	channel_code      ?string    @[omitempty; sql: 'channel_code'; sql_type: 'VARCHAR(255)'; zcomments: '渠道编码']
	merchant_order_id string     @[omitempty; required; sql: 'merchant_order_id'; sql_type: 'VARCHAR(255)'; zcomments: '商户订单编号']
	subject           string     @[omitempty; required; sql: 'subject'; sql_type: 'VARCHAR(255)'; zcomments: '商品标题']
	body              string     @[omitempty; required; sql: 'body'; sql_type: 'VARCHAR(255)'; zcomments: '商品描述']
	price             int        @[omitempty; required; sql: 'price'; sql_type: 'int'; zcomments: '支付金额，单位：分']
	channel_fee_rate  ?f64       @[omitempty; sql: 'channel_fee_rate'; sql_type: 'double'; zcomments: '渠道手续费，单位：百分比']
	channel_fee_price ?int       @[omitempty; sql: 'channel_fee_price'; sql_type: 'int'; zcomments: '渠道手续金额，单位：分']
	user_ip           string     @[omitempty; required; sql: 'user_ip'; sql_type: 'VARCHAR(255)'; zcomments: '用户 IP']
	expire_time       time.Time  @[default: now; omitempty; required; sql: 'expire_time'; sql_type: 'TIMESTAMP'; zcomments: '订单失效时间']
	success_time      ?time.Time @[default: now; omitempty; sql: 'success_time'; sql_type: 'TIMESTAMP'; zcomments: '订单支付成功时间']
	notify_time       ?time.Time @[default: now; omitempty; sql: 'notify_time'; sql_type: 'TIMESTAMP'; zcomments: '订单支付通知时间']
	extension_id      ?string    @[omitempty; sql: 'extension_id'; sql_type: 'CHAR(36)'; zcomments: '支付成功的订单拓展单编号']
	no                ?string    @[omitempty; sql: 'no'; sql_type: 'VARCHAR(255)'; zcomments: '订单号']
	refund_price      int        @[omitempty; required; sql: 'refund_price'; sql_type: 'int'; zcomments: '退款总金额，单位：分']
	channel_user_id   ?string    @[omitempty; sql: 'channel_user_id'; sql_type: 'VARCHAR(255)'; zcomments: '渠道用户编号']
	channel_order_no  ?string    @[omitempty; sql: 'channel_order_no'; sql_type: 'VARCHAR(255)'; zcomments: '渠道订单号']
	status            u8         @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
