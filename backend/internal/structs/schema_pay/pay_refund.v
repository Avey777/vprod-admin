module schema_pay

import time

// 支付退款表
@[table: 'pay_refund']
pub struct PayRefund {
pub:
	id                  string     @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	no                  string     @[omitempty; required; sql: 'no'; sql_type: 'VARCHAR(255)'; zcomments: '退款单号']
	channel_code        string     @[omitempty; required; sql: 'channel_code'; sql_type: 'VARCHAR(255)'; zcomments: '渠道编码']
	order_id            string     @[omitempty; required; sql: 'order_id'; sql_type: 'CHAR(36)'; zcomments: '支付订单编号 pay_order 表id']
	order_no            string     @[omitempty; required; sql: 'order_no'; sql_type: 'VARCHAR(255)'; zcomments: '支付订单 no']
	merchant_order_id   string     @[omitempty; required; sql: 'merchant_order_id'; sql_type: 'VARCHAR(255)'; zcomments: '商户订单编号（商户系统生成）']
	merchant_refund_id  string     @[omitempty; required; sql: 'merchant_refund_id'; sql_type: 'VARCHAR(255)'; zcomments: '商户退款订单号（商户系统生成）']
	pay_price           int        @[omitempty; required; sql: 'pay_price'; sql_type: 'int'; zcomments: '支付金额,单位分']
	refund_price        int        @[omitempty; required; sql: 'refund_price'; sql_type: 'int'; zcomments: '退款金额,单位分']
	reason              string     @[omitempty; required; sql: 'reason'; sql_type: 'VARCHAR(255)'; zcomments: '退款原因']
	user_ip             ?string    @[omitempty; sql: 'user_ip'; sql_type: 'VARCHAR(255)'; zcomments: '用户 IP']
	channel_order_no    string     @[omitempty; required; sql: 'channel_order_no'; sql_type: 'VARCHAR(255)'; zcomments: '渠道订单号，pay_order 中的 channel_order_no 对应']
	channel_refund_no   ?string    @[omitempty; sql: 'channel_refund_no'; sql_type: 'VARCHAR(255)'; zcomments: '渠道退款单号，渠道返回']
	success_time        ?time.Time @[omitempty; sql: 'success_time'; sql_type: 'TIMESTAMP'; zcomments: '退款成功时间']
	channel_error_code  ?string    @[omitempty; sql: 'channel_error_code'; sql_type: 'VARCHAR(255)'; zcomments: '渠道调用报错时，错误码']
	channel_error_msg   ?string    @[omitempty; sql: 'channel_error_msg'; sql_type: 'VARCHAR(255)'; zcomments: '渠道调用报错时，错误信息']
	channel_notify_data ?string    @[omitempty; sql: 'channel_notify_data'; sql_type: 'longtext'; zcomments: '支付渠道异步通知的内容']
	status              u8         @[default: 1; omitempty; sql: 'status'; sql_type: 'tinyint unsigned'; zcomments: 'Status 1: normal 2: ban | 状态 1 正常 2 禁用']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
