module main

import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.html
import nedpals.vex.ctx
import os
import strconv

const (
	port     = strconv.atoi(os.getenv('PORT')) or { 8080 }
	defaults = {
		'min':   '0'
		'max':   '-1'
		'float': 'false'
		'json':  'false'
	}
)

struct APIResult {
	title       string
	description string
	value       string
}

fn validate(name string, query_parameters map[string]string) string {
	value := query_parameters[name]
	return if value == '' { defaults[name] } else { value }
}

fn main() {
	mut app := router.new()

	// Serve the static files first
	app.route(.get, '/', fn (req &ctx.Req, mut res ctx.Resp) {
		res.send_file('static/index.html', 200)
	})

	app.route(.get, '/style.css', fn (req &ctx.Req, mut res ctx.Resp) {
		res.send_file('static/style.css', 200)
	})

	// Handle PRNG API requests
	app.route(.get, '/:generator', fn (req &ctx.Req, mut res ctx.Resp) {
		query_parameters := req.parse_query() or { defaults }

		min := validate('min', query_parameters)
		max := validate('max', query_parameters)
		float := validate('float', query_parameters)
		json := validate('json', query_parameters)

		generator := req.params['generator']

		result := generate_random_number(
			generator: generator
			min: min
			max: max
			float: float == 'true'
		)

		if json == 'true' {
			res.send_json(result, 200)
		} else {
			if result.value == '' {
				content := [
					html.tag(
						name: 'p'
						text: 'An error occured.'
					),
					html.tag(
						name: 'pre'
						text: result.description
					),
				]
				res.send_html(layout(result, content).html(), 200)
			} else {
				normalised_max := if max == '-1' { 'unspecified' } else { max }

				content := [
					html.tag(
						name: 'p'
						text: 'The value returned is $result.value'
					),
					html.tag(
						name: 'p'
						text: 'The configuration presented was:'
					),
					html.tag(
						name: 'ol'
						children: [
							html.tag(
								name: 'li'
								text: 'Generator: ${generator_names[generator]}'
							),
							html.tag(
								name: 'li'
								text: 'Minimum (inclusive): $min'
							),
							html.tag(
								name: 'li'
								text: 'Maximum (exclusive): $normalised_max'
							),
							html.tag(
								name: 'li'
								text: 'Float requested: ${float == 'true'}'
							),
						]
					),
				]
				res.send_html(layout(result, content).html(), 200)
			}
		}
	})

	server.serve(app, port)
}
