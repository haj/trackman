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

	$('.refresh_all_cars').click (event) =>
		$.get '/cars', gon.query_params ,(data) ->
			console.log gon.query_params
			console.log "cars positions updated!"
			handler.removeMarkers(window.markers);
			markers = handler.addMarkers(gon.data);
			window.markers = markers

