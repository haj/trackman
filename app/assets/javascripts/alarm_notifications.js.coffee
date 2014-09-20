$(document).ready ->

	$("#batch_archive").click ->	
		$("#archive_alarm_notifiations").submit()

	selectedItems = 0
	$(".alarm_notification_checkbox").click ->
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
