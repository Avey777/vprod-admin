module main

import rand
import benchmark

fn main() {
	mut b := benchmark.start()

	for _ in 0 .. 10000000 {
		mut u := rand.new_uuid_v7_session()
		u.next()
	}
	b.measure('new_uuid_v7_session')
}
