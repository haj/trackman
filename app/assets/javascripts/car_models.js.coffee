# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

	$("#batch_destroy").click ->	
		$("#destroy_car_models").submit()


	selectedItems = 0
	$(".car_model_checkbox").click ->
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
