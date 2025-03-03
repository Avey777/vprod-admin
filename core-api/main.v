module main

import log
import os

fn main() {
	mut l := log.Log{}
	l.set_output_stream(os.stdout())

	log.info('${@METHOD}  ${@MOD}.${@FILE_LINE}')
}
