ready = ->
  # to batch destroy selected alarms 
  $("#batch_archive").click ->  
    $("#archive_alarm_notifiations").submit()

  # logic that handles selecing alarms for batch destroy
  selectedItems = 0
  $(".alarm_notification_checkbox").click ->
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