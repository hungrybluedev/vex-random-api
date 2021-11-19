module main

import nedpals.vex.html

fn layout(result APIResult, content []html.Tag) html.Tag {
	title_text := '$result.title | Vex Random Number API'
	return html.html([
		html.block(
			name: 'head'
			children: [
				html.meta({
					'charset': 'UTF-8'
				}),
				html.meta({
					'http-equiv': 'X-UA-Compatible'
					'content':    'IE=edge'
				}),
				html.meta({
					'name':    'viewport'
					'content': 'width=device-width, initial-scale=1.0'
				}),
				html.tag(
					name: 'link'
					attr: {
						'rel':  'preconnect'
						'href': 'https://fonts.googleapis.com'
					}
				),
				html.tag(
					name: 'link'
					attr: {
						'rel':         'preconnect'
						'href':        'https://fonts.gstatic.com'
						'crossorigin': ''
					}
				),
				// Primary meta tags
				html.tag(
					name: 'title'
					text: title_text
				),
				html.meta({
					'name':    'title'
					'content': title_text
				}),
				html.meta({
					'name':    'description'
					'content': result.description
				}),
				// Open Graph tags
				html.meta({
					'property': 'og:type'
					'content':  'website'
				}),
				html.meta({
					'property': 'og:title'
					'content':  title_text
				}),
				html.meta({
					'property': 'og:description'
					'content':  result.description
				}),
				// Twitter tags
				html.meta({
					'property': 'twitter:title'
					'content':  title_text
				}),
				html.meta({
					'property': 'twitter:description'
					'content':  result.description
				}),
				// CSS
				html.tag(
					name: 'link'
					attr: {
						'rel':  'stylesheet'
						'href': 'https://fonts.googleapis.com/css2?family=PT+Serif:ital,wght@0,400;0,700;1,400;1,700&family=Jost:ital,wght@0,400;0,600;1,400;1,600&display=swap'
					}
				),
				html.tag(
					name: 'link'
					attr: {
						'rel':  'stylesheet'
						'href': 'style.css'
					}
				),
			]
		),
		html.block(
			name: 'body'
			children: [
				html.block(
					name: 'header'
					children: [
						html.tag(
							name: 'h1'
							attr: {
								'id': 'hero-heading'
							}
							text: result.title
						),
					]
				),
				html.block(
					name: 'main'
					children: content
				),
			]
		),
	])
}
