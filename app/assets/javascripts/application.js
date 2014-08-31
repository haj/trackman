// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// Framework Requires.
//= require ./framework/jquery-1.8.3.min
//= require ./framework/jquery-ui-1.10.1.custom.min
//= require ./framework/bootstrap.min
//= require ./framework/breakpoints
//= require ./framework/jquery.unveil.min
//= require ./framework/jqueryblockui
//= require ./page/select2.min
//
// Page Requires for a blank_template.
//= require ./page/jquery.sidr.min
//= require ./page/jquery.slimscroll.min
//= require ./page/pace.min
//= require ./page/jquery.animateNumbers
//= require messenger.min
//= require messenger-theme-future
//= require notifications
//
// Page Require for other pages.
//= require ./page/jquery.dataTables.min
//= require ./page/TableTools.min
//= require ./page/datatables.responsive
//= require_directory ./page
//
// Before Core Require
//= require datatables
//= require messages_notifications
//
// Core Require.
//= require ./template/core
//= require ./template/chat
//= require ./template/demo
//
//
// Our stuff Require.
//= require jquery_nested_form
//= require facebox
//= require 'best_in_place'
//
//= require jquery_ujs
//= require underscore
//= require regions
//= require gmaps/google
//= require cocoon
//= require jquery.regex-selector
//= require jquery.timetable
//= require work_schedules
//= require cars
//= require subscriptions
//= require alarms
//= require groups
//= require retina_tag
//= require bootstrap-datepicker
//= require jquery.timepicker
//= require datepair
//

$(document).ready(function(){
		$('.page-sidebar').css('height',$('.page-content').css('height'))
	}
)


