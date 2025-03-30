module schema

import time

// 支付示例订单表
@[table: 'pay_demo_order']
pub struct PayDemoOrder {
pub:
	id               string     @[auto_inc; primary; sql: 'id'; sql_type: 'CHAR(36)'; zcomments: 'UUID']
	user_id          string     @[omitempty; required; sql: 'user_id'; sql_type: 'VARCHAR(255)'; zcomments: '用户编号']
	spu_id           u64        @[omitempty; required; sql: 'spu_id'; sql_type: 'bigint unsigned'; zcomments: '商品编号']
	spu_name         string     @[omitempty; required; sql: 'spu_name'; sql_type: 'VARCHAR(255)'; zcomments: '商品名称']
	price            int        @[omitempty; required; sql: 'price'; sql_type: 'int'; zcomments: '价格，单位：分']
	pay_status       u8         @[omitempty; required; sql: 'pay_status'; sql_type: 'tinyint(1)'; zcomments: '是否支付']
	pay_order_id     ?u64       @[omitempty; sql: 'pay_order_id'; sql_type: 'bigint unsigned'; zcomments: '支付订单编号']
	pay_time         ?time.Time @[omitempty; sql: 'pay_time'; sql_type: 'TIMESTAMP'; zcomments: '付款时间']
	pay_channel_code ?string    @[omitempty; sql: 'pay_channel_code'; sql_type: 'VARCHAR(255)'; zcomments: '支付渠道']
	pay_refund_id    ?u64       @[omitempty; sql: 'pay_refund_id'; sql_type: 'bigint unsigned'; zcomments: '支付退款单号']
	refund_price     ?int       @[omitempty; sql: 'refund_price'; sql_type: 'int'; zcomments: '退款金额，单位：分']
	refund_time      ?time.Time @[omitempty; sql: 'refund_time'; sql_type: 'TIMESTAMP'; zcomments: '退款完成时间']

	updater_id ?string    @[omitempty; sql_type: 'CHAR(36)'; zcomments: '修改者ID']
	updated_at time.Time  @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Update Time | 修改日期']
	creator_id ?string    @[immutable; omitempty; sql_type: 'CHAR(36)'; zcomments: '创建者ID']
	created_at time.Time  @[immutable; omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Create Time | 创建日期']
	del_flag   u8         @[default: 0; omitempty; sql_type: 'tinyint(1)'; zcomments: '删除标记，0：未删除，1：已删除']
	deleted_at ?time.Time @[omitempty; sql_type: 'TIMESTAMP'; zcomments: 'Delete Time | 删除日期']
}
