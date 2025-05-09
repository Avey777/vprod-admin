module main

import rand
import benchmark

fn main() {
	println(rand.uuid_v4())
	println(rand.uuid_v7())

	mut b := benchmark.start()

	for _ in 0 .. 1000000 {
		mut u := rand.new_uuid_v7_session()
		u.next()
		dump(u.next())
	}
	b.measure('new_uuid_v7_session')
}
