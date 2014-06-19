# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	if (typeof gon != "undefined") && gon.resource == "cars"
		handler = Gmaps.build('Google')
		handler.buildMap { provider: { zoom: 10 }, internal: {id: gon.map_id}}, ->
			markers = handler.addMarkers(gon.data)
			window.markers = markers
			handler.bounds.extendWith(markers)
			handler.fitMapToBounds()
			refresh_rate = 3000


		refreshCarsMap = (data) ->
 			console.log "Refreshing cars"
 			console.log(data)
				handler.removeMarkers(window.markers)
				window.markers = handler.addMarkers(data)
		gon.watch('data', interval: 3000, refreshCarsMap)


				



