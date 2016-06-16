Reflux = require('reflux')
Actions = require('../utils/actions')

module.exports = Reflux.createStore

	listenables: [Actions],
	
	getCars:(url) ->
		self = @
		api.get(url).then (data) -> 
			console.log(data)
			self.cars = data
			self.triggerChange()
	
	triggerChange: ->
		@trigger 'change', @cars