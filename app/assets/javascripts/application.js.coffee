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
#= require_directory ./libraries/page
#
# Before Core Require
#= require ./libraries/datatables
#= require ./libraries/messages_notifications
#
# Core Require.
#= require ./libraries/core
#= require ./libraries/chat
#= require ./libraries/demo
#= require ./views/helpers/batch_action
#
# Our stuff Require.
#= require jquery_nested_form
#= require ./libraries/facebox
#= require ./libraries/best_in_place
#= require ./libraries/bootstrap-datepicker
#= require ./libraries/jquery.timepicker
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
#
# ########################### Views
#= require_tree ./views

#= require turbolinks

# ############## R(ock)eact
#= require react
#= require react_ujs
#= require bower_components/react-bootstrap/react-bootstrap.min
#= require bower_components/react-motion/build/react-motion
#= require bower_components/moment-duration-format/lib/moment-duration-format.js
#= require react_bootstrap
#= require components

ready = ->
  className = $('body').attr('data-class-name')
  window.currentView = try
    eval("new #{className}()")
  catch error
    new Views.ApplicationView()
  window.currentView.render()

$(document).ready(ready)
# $(document).on('ready page:load', ready)
# $(document).on('page:change', ready)
  # $(document).on 'page:load', pageLoad
  # $(document).on 'page:change', pageLoad

  # $(document).on 'page:restore', pageLoad
    # $(document).on 'page:restore', pageLoad
    # $(document).on 'page:before-change', ->
    #   window.currentView.cleanup()
    #   true
    # $(document).on 'page:restore', ->
    #   window.currentView.cleanup()
    #   pageLoad()
    #   true




