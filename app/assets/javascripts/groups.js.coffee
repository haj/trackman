# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	if (typeof gon != "undefined") && gon.resource == "groups"
		handler = Gmaps.build('Google')
		handler.buildMap { provider: { zoom: 10 }, internal: {id: gon.map_id}}, ->
			markers = handler.addMarkers(gon.data)
			window.markers = markers
			handler.bounds.extendWith(markers)
			handler.fitMapToBounds()
			refresh_rate = 3000
			setTimeout((-> car_refresh_loop(refresh_rate)), refresh_rate)

		car_refresh_loop = (refresh_rate) ->
			$.ajax gon.url, 
		        type: 'GET'
		        dataType: 'html'
		        data: gon.query_params
		        error: (jqXHR, textStatus, errorThrown) ->
		            console.log "AJAX Error: #{gon.url}"
		        success: (data, textStatus, jqXHR) ->
		            console.log "Refreshing cars"
					handler.removeMarkers(window.markers)
					window.markers = handler.addMarkers(gon.data)
			setTimeout((-> car_refresh_loop(refresh_rate)), refresh_rate)

				
