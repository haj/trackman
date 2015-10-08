$ ->

	# enable chosen js
	$('.chosen-select').chosen
		allow_single_deselect: true
		no_results_text: 'No results matched'
		width: '200px'

	# to mark a message as read
	$("#mark_as_read").click ->	
		$("#clicked_action").val('mark_as_read')	
		$("#mark_messages").submit()

	# to mark a message as unread
	$("#mark_as_unread").click ->	
		$("#clicked_action").val('mark_as_unread')	
		$("#mark_messages").submit()

	# to mark a message as deleted
	$("#mark_as_deleted").click ->		
		$("#clicked_action").val('mark_as_deleted')
		$("#mark_messages").submit()

	# to batch destroy selected messages
	$("#batch_destroy").click ->	
		$("#destroy_users").submit()

	# logic that handles selecing messages for batch destroy
	selectedItems = 0
	$(".user_checkbox").click ->
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