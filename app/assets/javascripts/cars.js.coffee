# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "page:change", ->
	handler = Gmaps.build('Google')

	handler.buildMap { provider: { zoom: 10 }, internal: {id: gon.map_id}}, ->
		markers = handler.addMarkers(gon.data)
		window.markers = markers
		handler.bounds.extendWith(markers)
		handler.fitMapToBounds()
		refresh_rate = 30000  
		setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)

	refresh_loop = (refresh_rate) ->
		$.ajax '/cars', 
	        type: 'GET'
	        dataType: 'html'
	        data: gon.query_params
	        error: (jqXHR, textStatus, errorThrown) ->
	            #console.log "AJAX Error: #{textStatus}"
	        success: (data, textStatus, jqXHR) ->
	            console.log "Successful AJAX call"
	            console.log gon.data
				handler.removeMarkers(window.markers)
				window.markers = handler.addMarkers(gon.data)
		setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)
			



