Fetch = require('whatwg-fetch')

module.exports = window.api =
  get: (url) ->
    fetch(url).then (response) ->
      response.json()
