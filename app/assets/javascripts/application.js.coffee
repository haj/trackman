# Framework Requires
#
#= require modularize
#= require ./libraries/jquery-1.8.3.min
#= require jquery.turbolinks
#= require ./libraries/jquery-ui-1.10.1.custom.min
#= require ./libraries/bootstrap.min
#= require ./libraries/breakpoints
#= require ./libraries/jquery.unveil.min
#= require ./libraries/jqueryblockui
#= require ./libraries/page/select2.min
#
# Page Requires for a blank_template
#= require ./libraries/page/jquery.sidr.min
#= require ./libraries/page/jquery.slimscroll.min
#= require ./libraries/page/pace.min
#= require ./libraries/page/jquery.animateNumbers
#= require ./libraries/messenger.min
#= require ./libraries/messenger-theme-future
#= require ./libraries/notifications
# require ./libraries/dataTables.bootstrap.min.js
#
# Page Require for other pages
#= require ./libraries/page/jquery.dataTables.min
#= require ./libraries/page/TableTools.min
#= require ./libraries/datatables.responsive
#= require ./libraries/page/d3
#= require_directory ./libraries/page
#
# Before Core Require
#= require ./libraries/datatables
#= require ./libraries/messages_notifications
#
# Core Require.
#= require ./libraries/core
#= require ./views/helpers/batch_action
#
# Our stuff Require.
#= require jquery_nested_form
#= require ./libraries/facebox
#= require ./libraries/jquery-scrolltofixed-min
#= require ./libraries/best_in_place
#= require ./libraries/bootstrap-datepicker
#= require ./libraries/jquery.timepicker
#= require ./libraries/jspdf.min
#= require ./libraries/jspdf_from_html
#= require ./libraries/jspdf_split_text_to_size
#= require ./libraries/jspdf_standard_fonts_metrics
#= require ./libraries/jspdf_addhtml
#= require ./libraries/html2canvas.min
#= require ./libraries/FileSaver.min

#= require ./libraries/datepair
#= require chosen-jquery
#= require cocoon
#= require gmaps/google
#= require jquery_ujs
#= require underscore
#= require ./libraries/jquery.regex-selector
#= require ./libraries/jquery.timetable
#= require retina_tag
#= require date
#= require ./libraries/query_report
#= require bower_components/momentjs/min/moment.min
#= require bower_components/pubsub-js/src/pubsub
#= require bower_components/moment-duration-format/lib/moment-duration-format
#
# ########################### Views
#= require_tree ./views

#= require turbolinks

# React
#= require components

ready = ->
  className = $('body').attr('data-class-name')
  window.currentView = try
    eval("new #{className}()")
  catch error
    new Views.ApplicationView()
  window.currentView.render()

$(document).ready(ready)



