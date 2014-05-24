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
			refresh_rate = 3000000  
			setTimeout((-> device_refresh_loop(refresh_rate)), refresh_rate)

		device_refresh_loop = (refresh_rate) ->
			$.ajax gon.device_url, 
		        type: 'GET'
		        dataType: 'html'
		        data: gon.device_query_params
		        error: (jqXHR, textStatus, errorThrown) ->
		            console.log "AJAX Error: #{gon.device_url}"
		        success: (data, textStatus, jqXHR) ->
		            console.log "Refreshing cars"
					handler.removeMarkers(window.markers)
					window.markers = handler.addMarkers(gon.device_data)
			setTimeout((-> device_refresh_loop(refresh_rate)), refresh_rate)