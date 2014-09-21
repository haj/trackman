# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  
  $("#batch_destroy").click ->  
    $("#destroy_work_schedules").submit()

  selectedItems = 0
  $(".work_schedule_checkbox").click ->
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


  $('.page-sidebar').css('height',$('.page-content').css('height'))
  
  # console.log("start : " + midnight);
  # console.log("end : " + start);
  # make the event "stick"
  calcCalendarHeight = ->
    h = $(window).height() - 40
    h
    
  date = new Date()
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()

  calendar = $("#calendar").timetable(
    header: {}
    editable: true
    selectable: true
    minTime: 0
    maxTime: 24
    slotMinutes: 60
    selectHelper: false
    events: [
      {
        title: ""
        start: 600
        end: 720
        allDay: false
        resource: "2"
      }
      {
        title: ""
        start: 830
        end: 1000
        allDay: false
        resource: "4"
      }
    ]
    select: (start, end, allDay, jsEvent, view, resource) ->
      midnight = new Date()
      midnight.setHours(0, 0, 0, 0)
      start_time = (start - midnight) / 60 / 1000
      end_time = (end - midnight) / 60 / 1000
      calendar.timetable "renderEvent",
        title: ""
        start: start_time
        end: end_time
        allDay: false
        resource: resource.id
      , true
      calendar.timetable "unselect"
      return

    eventClick: (event, jsEvent, view) ->
      view.calendar.removeEvents event._id
      return

    eventRender: (event, element, view) ->
      element.bind "contextmenu", (e) ->
        $("#contextMenuContainer").html "<div class='contextMenu'>Actions for event<br><br><input type='button' value='Action 1'><br><input type='button' value='Action 2'></div>"
        $("#contextMenuContainer").fadeIn()
        position = element.position()
        $("#contextMenuContainer").css
          left: position.left + 20
          top: position.top + 80

        $(document).click ->
          $("#contextMenuContainer").fadeOut()
          return

        false

      return

    height: calcCalendarHeight()
  )
  $(window).resize ->
    $("#calendar").timetable "option", "height", calcCalendarHeight()
    return

  $("#submit_calendar").click (ev) ->
    #console.log calendar.timetable("clientEvents")
    super_awesome_array = []
    i = 0

    for shift in calendar.timetable("clientEvents")
        super_awesome_array[i] = {start: shift.start, end: shift.end, wday: shift.resource }
        #console.log(shift.start + " ..... " + shift.end + " \n")
        i++ 

    work_schedule_name = $('#name').val()
    work_schedule_params = { name: work_schedule_name } 
    request = $.ajax { url: '/work_schedules', type: 'post', data: { shifts: super_awesome_array,  work_schedule:  work_schedule_params } }
    request.done (response, textStatus, jqXHR) ->
        console.log("response" + response)
     
    
    return

  return
