module main

import rand
import benchmark

fn main() {
	mut b := benchmark.start()

	for _ in 0 .. 1000000 {
		mut u := rand.new_uuid_v7_session()
		u.next()
		dump(rand.uuid_v7())
	}
	b.measure('new_uuid_v7_session')
}
