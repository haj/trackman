# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	if (typeof gon != "undefined") && gon.resource == "devices"
		handler = Gmaps.build('Google')
		handler.buildMap { provider: { zoom: 10 }, internal: {id: gon.map_id}}, ->
			markers = handler.addMarkers(gon.data)
			window.markers = markers
			handler.bounds.extendWith(markers)
			handler.fitMapToBounds()
			handler.getMap().setZoom(12)

		refreshDevicesMap = (data) ->
 			console.log "Refreshing devices"
 			console.log(data)
				handler.removeMarkers(window.markers)
				window.markers = handler.addMarkers(data)
		gon.watch('data', interval: 3000, refreshDevicesMap)


	$("#batch_destroy").click ->	
		$("#destroy_devices").submit()

	selectedItems = 0
	$(".device_checkbox").click ->
		if $(this).is(":checked")
			selectedItems++
			console.log selectedItems
			$("#quick-access").css "bottom", "0px"
			$(this).parent().parent().parent().toggleClass "row_selected"
		else
			selectedItems--
			console.log selectedItems
			$("#quick-access").css "bottom", "0px"
			$(this).parent().parent().parent().toggleClass "row_selected"
			$("#quick-access").css "bottom", "-115px"  if selectedItems is 0

		#Quick action dismiss Event
		$("#quick-access .btn-cancel").click ->
			$("#quick-access").css "bottom", "-115px"
			$("#email-list .checkbox").children("input").attr "checked", false
			$("#emails tbody tr").removeClass "row_selected"
