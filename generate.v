module main

import rand
import rand.seed
import rand.wyrand
import rand.mt19937
import rand.splitmix64

const generators = {
	'rng': get_rng()
	'mt':  get_mt()
	'sm':  get_sm()
}

const generator_names = {
	'rng': 'Default V RNG'
	'mt':  'Mersenne Twister 19937'
	'sm':  'Splittable Random from Java 8'
}

fn get_rng() rand.PRNG {
	mut rng := wyrand.WyRandRNG{}
	rng.seed(seed.time_seed_array(2))
	return rng
}

fn get_mt() rand.PRNG {
	mut rng := mt19937.MT19937RNG{}
	rng.seed(seed.time_seed_array(2))
	return rng
}

fn get_sm() rand.PRNG {
	mut rng := splitmix64.SplitMix64RNG{}
	rng.seed(seed.time_seed_array(2))
	return rng
}

struct GeneratorConfigStruct {
	generator string
	min       string
	max       string
	float     bool
}

fn generate_random_number(config GeneratorConfigStruct) APIResult {
	mut rng := generators[config.generator] or {
		valid_generators := generators.keys().join(', ')
		return APIResult{
			title: 'Invalid generator'
			description: 'An invalid generartor was specified. The valid generators are ${valid_generators}.'
			value: ''
		}
	}
	no_max := config.max == '-1'

	if config.float {
		range_min := config.min.f64()
		mut value := 0.0
		if no_max {
			value = rng.f64() + range_min
		} else {
			range_max := config.max.f64()
			value = rng.f64_in_range(range_min, range_max)
		}

		return APIResult{
			title: 'Value: $value'
			description: 'The server returned the value: $value'
			value: value.str()
		}
	} else {
		range_min := config.min.int()
		mut value := 0
		if no_max {
			value = rng.int31() + range_min
		} else {
			range_max := config.max.int()
			value = rng.int_in_range(range_min, range_max)
		}

		return APIResult{
			title: 'Value: $value'
			description: 'The server returned the value: $value'
			value: value.str()
		}
	}
}
