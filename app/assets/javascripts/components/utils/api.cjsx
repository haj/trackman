Fetch = require('whatwg-fetch')

module.exports = window.api =

	get: (url) ->
		fetch(url).then (response) ->
			response.json()

	getWithParams: (url, params) ->
		$.get(url, params).done (data) ->
			data
