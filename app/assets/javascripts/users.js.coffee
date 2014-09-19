# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
	$("#mark_as_read").click ->	
		$("#clicked_action").val('mark_as_read')	
		$("#mark_messages").submit()

	$("#mark_as_unread").click ->	
		$("#clicked_action").val('mark_as_unread')	
		$("#mark_messages").submit()

	$("#mark_as_deleted").click ->		
		$("#clicked_action").val('mark_as_deleted')
		$("#mark_messages").submit()

