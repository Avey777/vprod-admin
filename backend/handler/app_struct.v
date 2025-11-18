module handler

pub interface Repository {
	save(data string)
}

pub struct PostgresRepo {}

pub fn (r PostgresRepo) save(data string) {
	println('Saving to Postgres: ${data}')
}
