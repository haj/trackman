# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	if gon.resource == "devices"
		handler = Gmaps.build('Google')
		handler.buildMap { provider: { zoom: 10 }, internal: {id: gon.device_map_id}}, ->
			markers = handler.addMarkers(gon.device_data)
			window.markers = markers
			handler.bounds.extendWith(markers)
			handler.fitMapToBounds()
			refresh_rate = 3000  
			setTimeout((-> device_refresh_loop(refresh_rate)), refresh_rate)

		refreshDevicesMap = (data) ->
 			console.log "Refreshing devices"
 			console.log(data)
				handler.removeMarkers(window.markers)
				window.markers = handler.addMarkers(data)
		gon.watch('data', interval: 3000, refreshDevicesMap)