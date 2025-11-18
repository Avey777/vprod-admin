// domain/order_repository.v
module domain

pub struct Order {
pub:
	id     int
	amount f64
}

pub interface OrderRepository {
	find_by_id(id int) ?Order
	save(order Order) ?
}
