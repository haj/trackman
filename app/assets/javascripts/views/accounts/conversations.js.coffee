ready = ->
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
    if $(".js-conversation-inbox:checked").length > 0
      swal(   
        title: "Are you sure?"
        type: "warning"
        showCancelButton: true
        confirmButtonColor: "#DD6B55"
        confirmButtonText: "Yes, delete it!"
        closeOnConfirm: false 
        showLoaderOnConfirm: true
      , ()->
        $("#clicked_action").val('mark_as_deleted')
        $("#mark_messages").submit()
      )
    else
      swal("Error!", "You need to check at least 1 conversation!", "error")

  # to batch destroy selected messages
  $("#batch_destroy").click ->  
    $("#destroy_users").submit()

  # logic that handles selecing messages for batch destroy
  selectedItems = 0
  $(".user_checkbox").click ->
    if $(this).is(":checked")
      selectedItems++
      $("#quick-access").css "bottom", "0px"
      $(this).parent().parent().parent().toggleClass "row_selected"
    else
      selectedItems--
      $("#quick-access").css "bottom", "0px"
      $(this).parent().parent().parent().toggleClass "row_selected"
      $("#quick-access").css "bottom", "-115px"  if selectedItems is 0

    #Quick action dismiss Event
    $("#quick-access .btn-cancel").click ->
      $("#quick-access").css "bottom", "-115px"
      $("#email-list .checkbox").children("input").attr "checked", false
      $("#emails tbody tr").removeClass "row_selected"

$(document).ready(ready)
$(document).on("page:load", ready)